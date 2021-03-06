clc;
clear all;

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond =1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

[ gain, responseHat, residual] = fitCircularSimpleKalman( stimOri,respOri );

figure(101);
clf
set (gca,'fontsize', 24);
bar(gain)

