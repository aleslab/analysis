clc;
clear all;

%value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = actual stim ori


fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

% 
iCond =3; %When you have only 1 condition
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
    
    %sdEstimate_err(i)= minAngleDiff(sdEstimate(i),stimOri(i-1));
    
    
    
% plot (gain, 'r');
% hold on




end
[R,P]=corrcoef(err,RO);
%p=polyfit(sdErr,RO,1);
var_prox=var(err); % amount of variance in the error
var_dist=var(stimOri); %variance in the stimOri

p=polyfit(err,RO,1);





% figure(101);
% clf
% set (gca,'fontsize', 24);
% hold on
% plot (respOri,'r', 'Linewidth',3);
% % hold on
% % plot (stimOri,'g', 'Linewidth',2);
% hold on
% plot (estimate,'k','Linewidth',3);
% legend ('Participant response','Kalman Prediction');
% xlabel('Trial number');
% ylabel ('Orientation (degs)');


figure(102);
clf;
%whitey plot
set(gca,'fontsize', 24);
hold on
scatter (RO, err,80,'k','filled');
axis([-70,70,-70,70]);
hold on
legend ('Error (deg) vs relative orientation(deg)');
xlabel('Relative orientation of current trial compared to previous trial(deg)');
ylabel('Error on current trial (deg)');

figure (103);
clf;
%RO vs PE plot
set (gca,'fontsize', 24);
hold on
scatter (RO, PE,90,'k','filled');
axis([-70,70,-70,70]);
legend ('Prediction error (deg) vs relative orientation(deg)');
xlabel ('Relative orientation of current trial compared to previous trial(deg)');
ylabel('Amount of prediction error on current trial (deg)');


figure (104);
clf;
%kal estimate vs PE 
set (gca,'fontsize', 24);
hold on
scatter (estimateUpdate, PE,80,'k','filled');
axis([-100,100,-100,100]);
hold on
legend ('Prediction error (deg) vs Kalman predicition update(deg)');
xlabel('How much the Kalman updates its next prediction');
ylabel ('Prediction error on  current prediction');



figure(105);
clf;
set(gca,'fontsize', 24);
hold on
scatter (RO, sdEstimate,80,'k','filled');
axis([-60,60,-60,60]);
legend ('Naive estimate vs Relative orientation');
xlabel ('Relative orientation of current trial compared to previous trial(deg)');
ylabel('Naive estimate error on current trial (deg)');



figure(106);
clf;
set(gca,'fontsize', 24);
hold on
scatter (partcipantupdate, PE,80,'k','filled');
legend ('Prediction error (deg) vs partcipant predicition update(deg)');
xlabel('How much the participant updates the next response (deg)');
ylabel ('prediction error on current trial (deg)');

% figure(107);
% clf;
% set(gca,'fontsize', 24);
% hold on
% scatter (sdEstimate, PE,80,'k','filled');
% legend ('Prediction error (deg) vs sdUpdate(deg)');
% xlabel('How much the sd updates the next response (deg)');
% ylabel ('prediction error on current trial (deg)');
% 




