clc;
clear all;

%value = [10 13 15 28 15 	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = actual stim ori


fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

% 
iCond =1; %When you have only 1 condition
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
    
    kal_predict(i)=kal_predict(i-1);%kalman
    
    kal_predict(i)=kal_predict(i-1) + gain*minAngleDiff(stimOri(i),kal_predict(i-1));%kalman
    
    kal_predict(i) = wrapTo90(kal_predict(i));%kalman wrap function
    
%     naive_Estimate(i)  = stimOri(i-1) +gain*minAngleDiff(stimOri(i),stimOri(i-1));%naive
%     
%     naive_err(i)= minAngleDiff(naive_Estimate(i), stimOri(i)); %naive
%     
%     whitney_err(i) = minAngleDiff(respOri(i), stimOri(i)); %whitney error
%     
%     RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney/relative orientation
%     
%     part_PE_Err(i) = minAngleDiff(stimOri(i), respOri(i-1));% error in terms of PC participant predicitin error
%     
%     partcipant_update(i) = minAngleDiff(respOri(i), respOri(i-1));% how much the partcipnat updates
%     
%     kal_PE(i) = minAngleDiff(kal_predict(i-1), stimOri(i));%kalman prediciton error
%     
%     kal_Update(i) =  minAngleDiff(kal_predict(i),kal_predict (i-1));% how much the partcipant updates
%     
    
    
    
    
    
    
    
% plot (gain, 'r');
% hold on




end
%[a,b]=corrcoef(respOri, StimOri);

%[r,p]=corrcoef(part_PE_Err, partcipant_update);


var_prox=var(whitney_err); % amount of variance in the error
var_dist=var(stimOri); %variance in the stimOri
S=std(whitney_err);

% 
%  [ gain, responseHat, residual] = fitCircularSimpleKalman( stimOri,respOri );
%     
%     figure (600)
%     plot(responseHat)
%     
%     [ weights, responseHat, residual] = fitCircularStimulusAverage( stimOri,respOri,5 );
%     
%     figure (700)
%     plot(weights)


% legend ('Participant response','Kalman Prediction');
% xlabel('Trial number');
% ylabel ('Orientation (degs)');
%[ b, bint, r, p ] = analysis_func ( RO, whitney_err);

% whitneySD(iParticipant,iCond).r = r(1,1);
% whitneySD(iParticipant,iCond).p = p(1,1);
% whitneyFit(iParticipant,iCond).b = b;
% whitneyFit(iParticipant,iCond).bint = bint;
% whitneySlope(iParticipant,iCond) = b(1);
% whitneySlopeInt(iParticipant,iCond,:) = bint(1,:);
        
figure(102);
%clf;
%whitey plot
set(gca,'fontsize', 28);
hold on
scatter (RO, naive_err,90,'k','filled');
Xline = linspace (-90,90, 10);
%yHat = b*Xline+mean(whitney_err);
%plot (Xline, yHat,'LineWidth',6);
axis([-40,40,-40,40]);
%line([-90 90], [-90 90],'linewidth', 10);
box off
hold on
legend ('Participant error (deg) vs relative orientation(deg)');
xlabel('Relative orientation of current trial compared to previous trial(deg)');
ylabel('Participant error on current trial (deg)');

% nTrialsToSmooth = 30;
% trialWindow     = 14; %n Trials in either direction, total window 2x +1 
% nTrialsToTrim   = 15;
% nTrials = length(RO);
% 
% [sortRO,idx] = sort(RO);
% sort_err = whitney_err(idx);
% smooth_err = smooth(whitney_err(idx),nTrialsToSmooth);
% trim_err   = smooth_err((nTrialsToTrim+1):end-nTrialsToTrim);
% trimSortRO      = sortRO((nTrialsToTrim+1):end-nTrialsToTrim);
% 
% clear meanwhit_err sewhit_err trimsortRO
% 
% for iT = (trialWindow+1):(nTrials-trialWindow),
% 
%     trialsToSmooth = (iT-trialWindow) : (iT+trialWindow);
%     mean_err(iT-trialWindow) = mean(sort_err(trialsToSmooth));
%     se_err(iT-trialWindow)   = std(sort_err(trialsToSmooth))./sqrt(length(trialsToSmooth));
%     trimSortRO(iT-trialWindow)    = sortRO(iT);    
%     
% end
% seToConfInt = tinv(.975,length(trialsToSmooth)-1);
% 
% createShadedRegion(trimSortRO,mean_err,...
%     mean_err-seToConfInt*se_err,mean_err+seToConfInt*se_err,...
%     'g', 'linewidth', 6)
% 
% %createShadedRegion(x,y,y+2,y-2,':','color',[1 0 0])
% 
% 


% figure (103);
% clf;
% %RO vs PE plot
% set (gca,'fontsize', 24);
% hold on
% scatter (RO, kal_PE,90,'k','filled');
% axis([-70,70,-70,70]);
% legend ('Kalman Prediction error (deg) vs relative orientation(deg)');
% xlabel ('Relative orientation of current trial compared to previous trial(deg)');
% ylabel('Prediction made by Kalman error on current trial (deg)');


% figure (104);
% clf;
% %kal estimate vs PE 
% set (gca,'fontsize', 24);
% hold on
% scatter (partcipant_update_Update, kal_PE,80,'k','filled');
% axis([-100,100,-100,100]);
% hold on
% legend ('Kalman prediction error (deg) vs Kalman predicition update(deg)');
% xlabel('How much the Kalman updates its next prediction');
% ylabel ('Prediction error on  current prediction');

% [r,p]=corrcoef(stimOri,whitney_err);

% figure(105);
% clf;
% set(gca,'fontsize', 24);
% hold on
% scatter (RO, naive_Estimate,80,'k','filled');
% axis([-60,60,-60,60]);
% legend ('Naive estimate vs Relative orientation');
% xlabel ('Relative orientation of current trial compared to previous trial(deg)');
% ylabel('Naive estimate error on current trial (deg)');
% 
% 
%[ b, bint, r, p ] = analysis_func (part_PE_Err,partcipant_update);
[b,~,~,~, yUnwrap] = circularSlope90d(partcipant_update, part_PE_Err);

figure(106);
% clf
set(gca,'fontsize', 26);
hold on
scatter (part_PE_Err,partcipant_update ,90,'k','filled');
Xline = linspace (-90,90, 10);
yHat = b*Xline+mean(partcipant_update);
plot(Xline, yHat,'LineWidth',8,'Color',[.6 0 0]);
xlabel('Prediction error on current trial (deg)');
ylabel ('Update on the next response (deg)');
axis([-90,90,-90,90]);
%axis([-40,40,-40,40]);
%line([-40 40],[-40, 40],'linewidth', 6, 'k');
%line([-90 90], [-90 90],'linewidth', 8);
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


% figure(201)
% 
% scatter3(respOri(1:end-1),stimOri(2:end),respOri(2:end))
% % figure(107);
% clf;
% set(gca,'fontsize', 24);
% hold on
% scatter (naive_Estimate, naive_err,80,'k','filled');
% legend ('Naive estimate  error (deg) vs How much the estmate updates(deg)');
% xlabel('How much the naive estimate  updates the next response (deg)');
% ylabel ('Naive estimate error on current trial (deg)');


% figure(108);
% clf
% set (gca,'fontsize', 24);
% hold on
% plot (respOri,'r', 'Linewidth',3);
% % hold on
% % plot (stimOri,'g', 'Linewidth',2);
% hold on
% plot (naive_estimate,'g','Linewidth',3);
% legend ('Participant response','Naive estimate gain of 0.85');
% xlabel('Trial number');
% ylabel ('Orientation (degs)');

% figure (109);
% clf
% set (gca,'fontsize', 24);
% hold on
% scatter(stimOri,whitney_err ,80,'k','filled');
% xlabel('Stimulus orientation');
% ylabel('Whitney error');
% 
% 
% figure (309)
% clf
% set (gca,'fontsize', 24);
% hold on
% scatter(stimOri, respOri,80,'k','filled');
% xlabel('Stimulus orientation');
% ylabel('respOri');
% 
% 
% 
% 
% 
% %scatter (part_PE_Err, partcipant_update,80,'k','filled');
% % legend ('Partcipant response error (deg) vs partcipant response update(deg)');
% xlabel('How much the participant updates the next response (deg)');
% ylabel ('Participant error on current trial (deg)');

