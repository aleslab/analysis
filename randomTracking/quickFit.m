%% Choose and load a data file:
[filename pathname] = uigetfile()
%load data
load(fullfile(pathname,filename))
[sortedTrialData] = organizeData(sessionInfo,experimentData)

%%
opts = optimoptions(@lsqnonlin,'display','off');

nCond = length(sortedTrialData);
chunkTime = 10; % in seconds
chunkSize = round(chunkTime*sessionInfo.expInfo.monRefresh);

allGains = ones(nCond,1);
for i=1:5,
quickFitDelay;
delay = mean([fitData(:).delay])
quickFitGain;

for iCond = 1:nCond
   allGains(iCond)= mean([fitData(iCond).gain]);
end
allGains
end

%%
nCond = length(sessionInfo.conditionInfo);

for iCond = 1:nCond,
contrastList(iCond) = sessionInfo.conditionInfo(iCond).contrast;
nT = length(fitData(iCond).gain);
goodFits = find(fitData(iCond).resnorm< 1e9);

nT = length([fitData(iCond).gain(goodFits)]);
gainMean(iCond) = mean([fitData(iCond).gain(goodFits)]);
gainSEM(iCond)  = std([fitData(iCond).gain(goodFits)])./sqrt(nT);

delayMean(iCond) = mean([fitData(iCond).delay(goodFits)]);
delaySEM(iCond)  = std([fitData(iCond).delay(goodFits)])./sqrt(nT);

end

figure
subplot(1,2,1)
errorbar(contrastList, gainMean,gainSEM,'o')
title('Kalman Gain')
subplot(1,2,2)
errorbar(contrastList, delayMean,delaySEM,'o')
title('Delay')




