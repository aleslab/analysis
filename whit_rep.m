%function [sortedTrialData,sessionInfo, experimentData, err, RO] = whit_rep()
%    1    2     3     4     5    6     7     8  
fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

%respOri = [experimentData(1).trialData.respOri];
%stimOri = [experimentData(1).trialData.stimOri];


iCond = 1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];




    for i=  2:length(respOri);
        respOri(i)=respOri(i-1);
        err(i) = respOri(i) stimOri(i);
        RO(i) = stimOri(i-1) - stimOri(i);
        
        
        
        
%         disp (err);
         
    end 
         

%     RO(RO>180) = -180+(RO(RO>180)-180);
%     RO(RO<-180) = 180+(RO(RO<-180)+180);

    
    scatter (RO, err);


xlabel('relative orientation of previous trial'); % x-axis label
ylabel('error on current trial (deg)'); % y-axis label






    





    

    




