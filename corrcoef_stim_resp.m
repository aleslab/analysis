fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond =1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];



respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);


[r,p]=corrcoef(respOri, stimOri);



