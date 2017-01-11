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
    
    sdErr(i) = minAngleDiff(sdEstimate (i), stimOri(i));%whitney
     
    
% plot (gain, 'r');
% hold on


end
[R,P]=corrcoef(err,RO);



figure(101);
clf
set (gca,'fontsize', 22);
hold on
plot (respOri);
hold on
plot (stimOri,'g', 'Linewidth',3);
hold on
plot (estimate,'k','Linewidth',3);
legend ('Actual stimOri','Presponse','Kalman prediction');
xlabel('Time');
ylabel ('orientation');


figure(102);
clf;
set(gca,'fontsize', 22);
hold on
scatter (RO, err,50,'k','filled');
legend ('error on trial');
xlabel('RO');
ylabel('error');

figure (103);
clf;
set (gca,'fontsize', 22);
hold on
scatter (RO, PE,50,'k','filled');
legend ('Serial dependence');
xlabel ('RO');
ylabel('error made in prediction of position');


figure (104);
clf;
set (gca,'fontsize', 22);
hold on
scatter (estimateUpdate, PE,50,'b','filled');
legend ('responseUpdate');
xlabel('how much the kalman updates');
ylabel ('amount of prediction error');



figure(105);
clf;
set(gca,'fontsize', 22);
hold on
scatter (RO, sdErr,50,'g','filled');
legend ('whitney_sdErr')



