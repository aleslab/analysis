
%clc;
clear all;

stimOri=360*rand(20,1);
%stimOri = wrapTo90(360*rand(20,1));
var_prox = 100;

%This line is to simulate proximal noise from the observer. 
value=stimOri+randn(size(stimOri))*sqrt(var_prox);
%value = stimOri;
%stimOri = value;

clear estimate;
% % value=(respOri);
% % actual=(stimOri);

% fileToLoad = uigetfile; load(fileToLoad);
% [sortedData] = organizeData(sessionInfo,experimentData);
% value=[sortedData(iCond).trialData(:).respOri];
% % 
% iCond =2; %When you have only 1 condition
% respOri = [sortedData(iCond).trialData(:).respOri];
% stimOri = [sortedData(iCond).trialData(:).stimOri];

estimate_initial_time_point = 0;%define value for first Xhat

estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;
gain = .9;%distal / (distal +proximal);

err(1) = 0;
RO(1)  = 0;
estimateUpdate(1) = 0;
sdEstimate(1) = 0;
for i= 2:length (value);
    
    estimate(i)=estimate(i-1);
    
   % estimate(i)=estimate(i-1) + gain*minAngleDiff(value(i),estimate(i-1));
    estimate(i)=estimate(i-1) + gain*(stimOri(i)-estimate(i-1));
    sdEstimate(i)  = stimOri(i-1) + gain*minAngleDiff(stimOri(i),stimOri(i-1));
    
    estimate(i) = wrapTo90(estimate(i));
    
    err(i) = minAngleDiff(estimate (i), stimOri(i));%whitney
    
    RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
    
    PE(i) = minAngleDiff(stimOri(i),estimate (i-1));%PE
    
    estimateUpdate(i) =  minAngleDiff(estimate(i),estimate (i-1));
    
    sdErr(i) = minAngleDiff(sdEstimate (i), stimOri(i));%whitney
     
    
end

[R,P]=corrcoef(err,RO);



figure(101);
clf;
set (gca,'fontsize', 22);
%plot (p_response);

hold on
plot (stimOri,'g', 'Linewidth',2);
hold on
plot (estimate,'k','Linewidth',2);
legend ('Kalman prediction of blades given gain of 0.5', 'Actual blade orientaton');
xlabel('Time recorded');
ylabel ('Orientation of turbine blades in degrees');

% 
% figure(102);clf;
% scatter (RO, err,'r','filled');
% legend ('error on trial')
% xlabel('RO');
% ylabel('error');
% 
% figure (103);clf;
% set (gca,'fontsize', 22);
% scatter (RO, PE,'b','filled');
% legend ('prediction error');
% xlabel ('RO');
% ylabel('amount of prediciton error');
% 
% 
figure (104);
clf;
set (gca,'fontsize', 22);
hold on
scatter (estimateUpdate, PE,'b','filled');
legend ('responseUpdate');
xlabel('how much the estimate updates');
ylabel ('amount of prediction error');
% 
% 
% 
% figure(105);clf;
% scatter (RO, sdErr,'g','filled');
% legend ('whitney_sdErr')
% 
% 
