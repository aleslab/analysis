fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

% 
iCond =3; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);

for i= 2:length (respOri);
    

whitney_err(i) = minAngleDiff(respOri(i), stimOri(i)); %whitney error
    
RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney/relative orientation
   

end

%[ b, bint, r, p ] = analysis_func ( RO, whitney_err);
[b,~,~,~, yUnwrap] = circularSlope90d(whitney_err, RO);

figure(102);
%clf;
%whitey plot
set(gca,'fontsize', 28);
hold on
scatter (RO, whitney_err,0,'k','filled');
Xline = linspace (-90,90, 10);
yHat = b*Xline+mean(whitney_err);
plot (Xline, yHat,'LineWidth',6);
axis([-40,40,-40,40]);
%line([-90 90], [-90 90],'linewidth', 10);
box off
hold on
legend ('Participant error (deg) vs relative orientation(deg)');
xlabel('Relative orientation of current trial compared to previous trial(deg)');
ylabel('Participant error on current trial (deg)');

nTrialsToSmooth = 30;
trialWindow     = 14; %n Trials in either direction, total window 2x +1 
nTrialsToTrim   = 15;
nTrials = length(RO);

[sortRO,idx] = sort(RO);
sort_err = whitney_err(idx);
smooth_err = smooth(whitney_err(idx),nTrialsToSmooth);
trim_err   = smooth_err((nTrialsToTrim+1):end-nTrialsToTrim);
trimSortRO      = sortRO((nTrialsToTrim+1):end-nTrialsToTrim);

clear meanwhit_err sewhit_err trimsortRO

for iT = (trialWindow+1):(nTrials-trialWindow),

    trialsToSmooth = (iT-trialWindow) : (iT+trialWindow);
    mean_err(iT-trialWindow) = mean(sort_err(trialsToSmooth));
    se_err(iT-trialWindow)   = std(sort_err(trialsToSmooth))./sqrt(length(trialsToSmooth));
    trimSortRO(iT-trialWindow)    = sortRO(iT);    
    
end
seToConfInt = tinv(.975,length(trialsToSmooth)-1);

createShadedRegion(trimSortRO,mean_err,...
    mean_err-seToConfInt*se_err,mean_err+seToConfInt*se_err,...
    'g', 'linewidth', 6)

createShadedRegion(x,y,y+2,y-2,':','color',[1 0 0])

