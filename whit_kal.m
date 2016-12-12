
%clc;
clear all;


stimOri = wrapTo90(360*rand(200,1));
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
% distal = var_dist;
% proximal = var_prox;

% var_prox=var(err); % amount of variance in the error
% var_dist=var(stimOri); %variance in the stimOri
% gain=var_dist / (var_dist + var_prox);

gain = .6;%var_dist / (var_dist + var_prox);
%estimate = estimate+gain*value - estimate;

err(1) = 0;
RO(1)  = 0;
estimateUpdate(1) = 0;
sdEstimate(1) = 0;
for i= 2:length (value);
    
    estimate(i)=estimate(i-1);

    
    estimate(i)=estimate(i-1) + gain*minAngleDiff(value(i),estimate(i-1));
    sdEstimate(i)  = value(i-1) + gain*minAngleDiff(value(i),value(i-1));
    estimate(i) = wrapTo90(estimate(i));
    
     err(i) = minAngleDiff(estimate (i), stimOri(i));%whitney
     RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
     PE(i) = minAngleDiff(stimOri(i),estimate (i-1));%PE
     estimateUpdate(i) =  minAngleDiff(estimate(i),estimate (i-1)); %how much the est updates
     
     sdErr(i) = minAngleDiff(sdEstimate (i), stimOri(i));%whitney
     
    
end

[R,P]=corrcoef(PE,RO);
average= mean(PE);


figure(101);
clf;
%plot (p_response);

hold on
plot (stimOri, 'x');
plot (estimate, 'c*');
legend ('p_response', 'actual_stimOri', 'modelled kalman resposne given calibrated gain')
xlabel('trial number')
ylabel ('orientation');


figure(102);clf;
scatter (RO, err,'r','filled');
legend ('error on trial')
xlabel('RO');
ylabel('error');
% hold on
% lsline(ax1);

figure (103);clf;
scatter (RO, PE,'b','filled');
legend ('prediction error');
xlabel ('RO');
ylabel('amount of prediciton error');


figure (104);clf;
scatter (estimateUpdate, PE,'b','filled');
legend ('responseUpdate');
xlabel('how much the estimate updates');
ylabel ('amount of prediction error');



figure(105);clf;
scatter (RO, sdErr,'g','filled');
legend ('whitney_sdErr')


