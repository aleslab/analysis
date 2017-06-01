clc;
clear all;

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond =1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];


[ weights, responseHat, residual] = fitCircularStimulusAverage( stimOri,respOri,11 );

%[ gain, responseHat, residual] = fitCircularSimpleKalman( stimOri,respOri );


disp('weights')

figure(101);
clf
set (gca,'fontsize', 24);
bar(weights)



