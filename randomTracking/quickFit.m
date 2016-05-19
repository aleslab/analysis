%% Choose and load a data file:
[filename pathname] = uigetfile()
%load data
load(fullfile(pathname,filename))
[sortedTrialData] = organizeData(sessionInfo,experimentData)

%%
opts = optimoptions(@lsqnonlin,'display','off');

nCond = length(sortedTrialData);
chunkTime = 15; % in seconds
chunkSize = round(chunkTime*sessionInfo.expInfo.monRefresh);

allGains = ones(nCond,1);
for i=1:10,
quickFitDelay;
fitDataDelay = fitData;
delay = mean([fitData(:).delay])
quickFitGain;

for iCond = 1:nCond
   allGains(iCond)= mean([fitData(iCond).gain]);
end
%allGains
end

%%
nCond = length(sessionInfo.conditionInfo);

for iCond = 1:nCond,
contrastList(iCond) = sessionInfo.conditionInfo(iCond).contrast;
nT = length(fitData(iCond).gain);
goodFits = find(fitData(iCond).resnorm< 1e6);

nT = length([fitData(iCond).gain(goodFits)]);
gainMean(iCond) = mean([fitData(iCond).gain(goodFits)]);
gainSEM(iCond)  = std([fitData(iCond).gain(goodFits)])./sqrt(nT);

delayMean(iCond) = mean([fitDataDelay(iCond).delay(goodFits)]);
delaySEM(iCond)  = std([fitDataDelay(iCond).delay(goodFits)])./sqrt(nT);

end

%% make plots

timePerFrame = 1000*sessionInfo.expInfo.ifi; %Frame duration in milliseconds

figure(142)
clf

%subplot(1,2,1)
h=bar(contrastList, gainMean,'k')
set(h,'faceColor','w')
hold on;
errorbar(contrastList, gainMean,gainSEM,'.k','linewidth',4)

xlabel('Contrast')
ylabel('Kalman Gain')

figure(143)
clf
h=bar(contrastList, timePerFrame*delayMean,'k')
set(h,'faceColor','w')
hold on;
errorbar(contrastList, timePerFrame*delayMean,timePerFrame*delaySEM,'.k','linewidth',4)
title('Delay')



[contrastSorted,contrastOrder] = sort(contrastList);

disp(['Participant: ' sessionInfo.participantID])
disp(['Contrast:    ' num2str(contrastSorted)]);
disp(['Kalman Gain: ' num2str(gainMean(contrastOrder))]);

disp(['Delay: ' num2str(timePerFrame*delayMean(contrastOrder))]);

