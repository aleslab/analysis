

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond = 1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

RO_initial_time_point=0;

    for i=  1:length(respOri);
        %respOri(i)=stimOri(i);
        
        %err(i) = minAngleDiff(respOri, stimOri);
        err(i) = minAngleDiff(respOri(i), stimOri(i));
        RO(i) = minAngleDiff(stimOri(i-1), stimOri(i));
%         if abs (RO(i)) > 180;
%             RO(i)=360+RO(i);
%         else
%             
%             RO(i)=360-RO(i);
%         end
%         %RO = RO - 360*sign(RO);
%         %end
%         elseif RO<180
%             RO = RO + 360*sign(RO);
%         end;
        
%         if
%             RO(i)(RO>180(i)) = -180+(RO(RO>180)-180);
%         else
%             RO(i)(RO<-180(i)) = 180+(RO(RO<-180)+180);
%             
%         end

    
        %err(i) = (respOri(i) - stimOri(i));
        %RO(i) = stimOri(i-1) - stimOri(i);
   
        
        
%         disp (err);
         
    end 
         

data=respOri;
sem=std(data)/sqrt(length(data));



       figure;
       scatter (RO, err);
       
xlabel('relative orientation of previous trial'); % x-axis label
ylabel('error on current trial (deg)'); % y-axis label

% figure
% xlabel('relative orientation of trial'); % x-axis label
% ylabel('resp on current trial (deg)'); % y-axis label
% 
% 




    





    

    




