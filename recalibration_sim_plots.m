fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

% 
iCond =1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);

estimate_initial_time_point = 0;%define value for first Xhat

kal_predict(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;

gain = .5;

part_PE_Err(1) = 0;
RO(1)  = 0;
for i= 2:length (respOri);
    
    kal_predict(i)=kal_predict(i-1);%kalman
    
    kal_predict(i)=kal_predict(i-1) + gain*minAngleDiff(stimOri(i),kal_predict(i-1));%kalman
    
    kal_predict(i) = wrapTo90(kal_predict(i));%kalman wrap function
   

end


figure(101);
clf
% set (gca,'fontsize', 24);
% hold on
% plot (respOri,'r', 'Linewidth',3);
% hold on
plot (stimOri,'k', 'Linewidth',2);
% hold on
% plot (kal_predict,'k','Linewidth',3);

