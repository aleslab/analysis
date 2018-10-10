clc;
clear all;

%stimOri = [10 12 15 11 15 16 11 13 13 14 11 10 13 16 12 11 14 17 12 18 ]; % value = actual stim ori
%true =    [ 13.2 13.1 14 13.4 13.2 13.1 14.5 12.5 12.5 11.5 13.5 12.5 11.5 12.4 13.5 13.8 13.1 13 13.5];  
% stimOri = [ 10 10 10 10 60 60 60 60 11 11 11 11 90 90 90 90 10 10 10 10 50 50 50 50 5 5 5 5 ];
% measuOri= [ 12 12 12 14 58 62 64 59 10 13 12 13 88 87 92 91 12 12 14 12 48 27 47 48 3 6 3 4 ];

stimOri = [ 10 10 10 10 100 100 100 100 5  5 5 5 130 130 130 130 10 10 10 10 150 150 150 150 50 50 50 50];
measuOri= [ 12 15 14 13 97  95  96   98 7  4  7 7 125 127 129 135 8 9 12 13  145 148 146 159 48 45 52 54
estimate_initial_time_point = 0;%define value for first Xhat

kal_predict(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;

% gain = .3;
% weight =0.5;
%estimate = measuOri*0.9;



for i= 2:length (stimOri);
    
    kal_predict(i)=kal_predict(i-1);%kalman
    
    kal_predict(i)=kal_predict(i-1) + gain*minAngleDiff(stimOri(i),kal_predict(i-1));%kalman
    
    kal_predict(i) = wrapTo90(kal_predict(i));%kalman wrap function
   
    estimate (i) = 0.7*measuOri(i)+ 0.3*measuOri(i-1);

end

%  
figure(102);
clf;
%simulation plot
set(gca,'fontsize', 28,'FontWeight', 'Bold');
hold on
plot (stimOri, 'k','LineWidth',8) 
hold on
plot (kal_predict, 'r','LineWidth',8)
hold on
plot(measuOri,'g', 'LineWidth',8)
box off
axis([0,20,0,170]);
hold on
% legend ('Participant error (deg) vs relative orientation(deg)');
xlabel('Time');
ylabel('Stimulus value');


figure(103);
clf;
%simulation plot
set(gca,'fontsize', 28,'FontWeight', 'Bold');
hold on
plot (stimOri, 'k','LineWidth',8) 
hold on
plot (measuOri, 'r','LineWidth',8)
hold on
plot (estimate,'g','LineWidth',8)
box off
axis([0,20,0,60]);
hold on
% legend ('Participant error (deg) vs relative orientation(deg)');
xlabel('Time');
ylabel('Stimulus value');







% figure (103);
% clf;
% %RO vs PE plot
% set (gca,'fontsize', 24);
% hold on
% scatter (RO, kal_PE,90,'k','filled');
% axis([-70,70,-70,70]);
% legend ('Kalman Prediction error (deg) vs relative orientation(deg)');
% xlabel ('Relative orientation of current trial compared to previous trial(deg)');
% ylabel('Prediction made by Kalman error on current trial (deg)');


% figure (104);
% clf;
% %kal estimate vs PE 
% set (gca,'fontsize', 24);
% hold on
% scatter (partcipant_update_Update, kal_PE,80,'k','filled');
% axis([-100,100,-100,100]);
% hold on
% legend ('Kalman prediction error (deg) vs Kalman predicition update(deg)');
% xlabel('How much the Kalman updates its next prediction');
% ylabel ('Prediction error on  current prediction');

% [r,p]=corrcoef(stimOri,whitney_err);


% 
