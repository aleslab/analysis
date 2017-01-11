
%clc;
clear all;

%stimOri=360*rand(20,1);
stimOri = wrapTo90 (360*rand(100,1));
var_prox = 100;
stimOri = stimOri+randn(size(stimOri))*sqrt(var_prox);

%This line is to simulate proximal noise from the observer. 
%value=stimOri+randn(size(stimOri))*sqrt(var_prox);
%value = stimOri;
%stimOri = value;

clear estimate;
estimate_initial_time_point = 0;%define value for first Xhat
estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;
gain = .2;%distal / (distal +proximal);

err(1) = 0;
RO(1)  = 0;
estimateUpdate(1) = 0;
sdEstimate(1) = 0;

for i= 2:length (stimOri);
    
    estimate(i)=estimate(i-1);
    
    estimate(i)=estimate(i-1) + gain*minAngleDiff(stimOri(i),estimate(i-1));
    
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
plot (p_response);

hold on
%kalman track figure
plot (stimOri,'g', 'Linewidth',3);
hold on
plot (estimate,'k','Linewidth',3);
legend ('Actual posistion of car','Kalman prediction');
xlabel('Time in secs');
ylabel ('Movement of car');


figure(102);
%whitney figure
clf;
set(gca,'fontsize', 22);
hold on
scatter (err, RO, 200,'k','filled');
legend ('error on trial');
xlabel('RO');
ylabel('error');

% figure (103);
% %precition error to RO figure
% clf;
% set (gca,'fontsize', 22);
% hold on
% scatter (RO, PE,200,'k','filled');
% legend ('Serial dependence');
% xlabel ('RO');
% ylabel('error made in prediction of position');


figure (104);
clf;
%response update figure
set (gca,'fontsize', 22);
hold on
scatter (estimateUpdate, PE,200,'b','filled');
legend ('responseUpdate');
xlabel('how much the kalman updates');
ylabel ('amount of prediction error');



% figure(105);
%standard error figure
% clf;
% set(gca,'fontsize', 22);
% scatter (RO, sdErr,200,'g','filled');
% legend ('whitney_sdErr')

% 
