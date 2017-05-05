clc;
clear all;

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond =3; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];


[ weights, responseHat, residual] = fitCircularStimulusAverage( stimOri,respOri,6 );



