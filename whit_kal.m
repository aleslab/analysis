

clear all;

stimOri=360*rand(70,1);
var_prox = 1000;
stimOri = stimOri+randn(size(stimOri))*sqrt(var_prox);
% respOri = stimOri-20;

%stimOri = [30 45 60 90 240 280 300 320 360];


% stimOri = wrapTo90(10*rand(150,1));
% var_prox = 525;
% stimOri = stimOri+randn(size(stimOri))*sqrt(var_prox);

%This line is to simulate proximal noise from the observer. 
%value=stimOri+randn(size(stimOri))*sqrt(var_prox);
%value = stimOri;
%stimOri = value;

clear estimate;
estimate_initial_time_point = 0;%define value for first Xhat
estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;
gain = 0.5;%distal / (distal +proximal);

err(1) = 0;
RO(1)  = 0;
estimateUpdate(1) = 0;
sdEstimate(1) = 0;

for i= 2:length (stimOri);
    
    estimate(i)=estimate(i-1);
    
    estimate(i)=estimate(i-1) + gain*minAngleDiff(stimOri(i),estimate(i-1));
    
    sdEstimate(i)  = stimOri(i-1) + gain*minAngleDiff(stimOri(i),stimOri(i-1));
    
    estimate(i) = wrapTo90(estimate(i));
    
    err(i) = minAngleDiff(estimate(i), stimOri(i));%whitney
    
    RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
    
    PE(i) = minAngleDiff(stimOri(i),estimate (i-1));%PE
    
    estimateUpdate(i) =  minAngleDiff(estimate(i),estimate (i-1));
    
    sdErr(i) = minAngleDiff(sdEstimate (i), stimOri(i));%whitney
     
    
end

[R,P]=corrcoef(err,RO);

p=polyfit(sdErr,RO,1);


% figure(101);
% clf;
% set (gca,'fontsize', 22);
% %plot (p_response);
% 
% hold on
% %kalman track figure
% plot (stimOri,'r', 'Linewidth',4);
% hold on
% plot (estimate,'k','Linewidth',4);
% legend ('Recorded orientation ','Kalman prediction');
% xlabel('Time in secs');
% ylabel ('Movement of blades');
% 

% figure(102);
% %whitney figure
% clf;
% set(gca,'fontsize', 25);
% hold on
% scatter (RO, err, 200,'k','filled');
% 
% xlabel('Relative Orientation of current compared to previous trial(deg) ');
% ylabel('Error on current trial (deg)');

% % figure (103);
% % %precition error to RO figure
% % clf;
% % set (gca,'fontsize', 22);
% % hold on
% % scatter (RO, PE,200,'k','filled');
% % legend ('Serial dependence');
% % xlabel ('RO');
% % ylabel('error made in prediction of position');
% 
% 
% figure (104);
% clf;
% %response update figure
% set (gca,'fontsize', 25);
% hold on
% scatter (estimateUpdate, PE,200,'b','filled');
% legend (' Prediction Update');
% xlabel('How much the kalman updates');
% ylabel ('Amount of prediction error');
% 
% 
% 
figure(105);
%standard error figure
clf;
set(gca,'fontsize', 28) % 'XTickLabel',{'-100','-90','-80','-70','-60','-50','-40', '30', '-20', '-10', '0','10','20','30','40','50','60','70', '80', '90', '100'},  'YTickLabel',{'-50', '-40', '-30', '-20', '-10', '0', '10', '20', '30', '40', '50'});
hold on
scatter (RO, sdErr,200,'g','filled');
axis([-60,60,-60,60]);
legend ('Positive values on the abscissa indicate that the previous trial was more clockwise than the present trial, and positive errors indicate that the reported orientation was more clockwise?')
xlabel('Relative Orientation of current compared to previous trial(deg) ');
ylabel('Error on current trial (deg)');


