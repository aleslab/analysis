clc;
clear all;

%value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = actual stim ori


fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

% 
iCond =3; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);

estimate_initial_time_point = 0;%define value for first Xhat

kal_predict(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;

gain = .4;


part_PE_Err(1) = 0;
RO(1)  = 0;
for i= 2:length (respOri);
    
    
    part_PE_Err(i) = minAngleDiff(stimOri(i), respOri(i-1));% error in terms of PC participant predicitin error
    
    partcipant_update(i) = minAngleDiff(respOri(i), respOri(i-1));% how much the partcipnat updates
    


end

[b,~,~,~, yUnwrap] = circularSlope90d(partcipant_update, part_PE_Err);

figure(106);
% clf
set(gca,'fontsize', 26);
hold on
scatter (part_PE_Err,partcipant_update ,0);
% Xline = linspace (-90,90, 10);
% yHat = b*Xline+mean(partcipant_update);
%plot(Xline, yHat,'LineWidth',8,'Color',[0 0 1]);
%plot(Xline, yHat,'LineWidth',8,'Color',[1 0 0]);
xlabel('Response error on current trial (deg)');
ylabel ('Change on the next response (deg)');
axis([-90,90,-90,90]);
%axis([-45,45,-45,45]);
%line([-40 40],[-40, 40],'linewidth', 6, 'k');
line([-90 90], [-90 90],'linewidth', 8);
% box off
box off

nTrialsToSmooth = 30;
trialWindow     = 14; %n Trials in either direction, total window 2x +1 
nTrialsToTrim   = 15;
nTrials = length(part_PE_Err);

[sortPE,idx] = sort(part_PE_Err);
sortPptUpdate = partcipant_update(idx);
smoothPptUpdate = smooth(partcipant_update(idx),nTrialsToSmooth);
trimPptUpdate   = smoothPptUpdate((nTrialsToTrim+1):end-nTrialsToTrim);
trimSortPE      = sortPE((nTrialsToTrim+1):end-nTrialsToTrim);

clear meanPptUpdate sePptUpdate trimSortPE

for iT = (trialWindow+1):(nTrials-trialWindow),

    trialsToSmooth = (iT-trialWindow) : (iT+trialWindow);
    meanPptUpdate(iT-trialWindow) = mean( sortPptUpdate(trialsToSmooth));
    sePptUpdate(iT-trialWindow)   = std(sortPptUpdate(trialsToSmooth))./sqrt(length(trialsToSmooth));
    trimSortPE(iT-trialWindow)    = sortPE(iT);    
    
end

seToConfInt = tinv(.975,length(trialsToSmooth)-1);

createShadedRegion(trimSortPE,meanPptUpdate,...
    meanPptUpdate-seToConfInt*sePptUpdate,meanPptUpdate+seToConfInt*sePptUpdate,...
    'k','linewidth', 8)

