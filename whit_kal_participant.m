clc;
clear all;

%value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = actual stim ori


fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

% 
iCond =1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);

estimate_initial_time_point = 0;%define value for first Xhat

estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;

gain = .9;%distal / (distal +proximal);
%estimate = estimate+gain*value - estimate;

err(1) = 0;
RO(1)  = 0;
for i= 2:length (respOri);
    
    estimate(i)=estimate(i-1);
    
    estimate(i)=estimate(i-1) + gain*minAngleDiff(stimOri(i),estimate(i-1));
    
    sdEstimate(i)  = stimOri(i-1) + gain*minAngleDiff(stimOri(i),stimOri(i-1));
    
    estimate(i) = wrapTo90(estimate(i));
    
    err(i) = minAngleDiff(respOri(i), stimOri(i));%whitney
    
    RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
    
    PE(i) = minAngleDiff(stimOri(i),estimate (i-1));%PE
    
    estimateUpdate(i) =  minAngleDiff(estimate(i),estimate (i-1));
    
    partcipantupdate(i) = minAngleDiff(respOri(i), respOri(i-1));
    
    sdErr(i) = minAngleDiff(sdEstimate (i), stimOri(i));%whitney
     
    
% plot (gain, 'r');
% hold on




end
[R,P]=corrcoef(err,RO);
p=polyfit(sdErr,RO,1);
var_prox=var(err); % amount of variance in the error
var_dist=var(stimOri); %variance in the stimOri





% 
% figure(101);
% clf
% set (gca,'fontsize', 26);
% hold on
% plot (respOri,'r', 'Linewidth',3);
% % hold on
% % plot (stimOri,'r', 'Linewidth',2);
% % hold on
% plot (estimate,'k','Linewidth',3);
% legend ('Response','Kalman');
% xlabel('Time');
% ylabel ('Orientation in degrees');


figure(102);
clf;
set(gca,'fontsize', 26);
hold on
scatter (RO, err,70,'k','filled');
hold on
legend ('Error on trial');
xlabel('Relative Orientation');
ylabel('Error in degrees');

% figure (103);
% clf;
% set (gca,'fontsize', 22);
% hold on
% scatter (RO, PE,90,'k','filled');
% legend ('Serial dependence');
% xlabel ('RO');
% ylabel('error made in prediction of position');


% figure (104);
% clf;
% set (gca,'fontsize', 22);
% hold on
% scatter (estimateUpdate, PE,80,'b','filled');
% hold on
% legend ('Response Update');
% xlabel('How much the kalman updates');
% ylabel ('Amount of prediction error');
% 
% % 
% % 
% figure(105);
% clf;
% set(gca,'fontsize', 22);
% hold on
% scatter (RO, sdErr,50,'g','filled');
% legend ('whitney_sdErr')
% % 
% figure(106);
% clf;
% set(gca,'fontsize', 22);
% hold on
% scatter (partcipantupdate, PE,80,'k','filled');
% xlabel('How much the participant updates');
% ylabel ('Amount of prediction error');
% legend ('PE');
% 
% % 
% % 
% % 
