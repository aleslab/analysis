

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond = 1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];


    for i=  1:length(respOri);
        %respOri(i)=stimOri(i);
        err(i) = minAngleDiff(respOri, stimOri);
        RO(i) =(stimOri(i-1) - stimOri(i));
    
        
   
        
        
%         disp (err);
         
    end 
         

%     RO(RO>180) = -180+(RO(RO>180)-180);
%     RO(RO<-180) = 180+(RO(RO<-180)+180);

       figure;
       scatter (RO, err, 'r');
       %lsline
       %figure;
       %scatter(stimOri, respOri);
% %    %plot for each con next job
       %gplotmatrix(RO,err,iCond);
% 
% 
xlabel('relative orientation of previous trial'); % x-axis label
ylabel('error on current trial (deg)'); % y-axis label

% figure
% xlabel('relative orientation of trial'); % x-axis label
% ylabel('resp on current trial (deg)'); % y-axis label
% 
% 




    





    

    




