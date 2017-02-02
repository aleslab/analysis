

clear all;

stimOri=[300 296 299 292 290 280 278 272 270 265 266 261 260 255 250 220 200 190 160 150 145 130 100 90 80 77 70 68 60 50 40 20 0 20 60 80];

%stimOri = stimOri+randn(size(stimOri))*sqrt(var_prox);
% respOri = stimOri-20;




% stimOri = wrapTo90(10*rand(150,1));
% var_prox = 525;
% stimOri = stimOri+randn(size(stimOri))*sqrt(var_prox);

%This line is to simulate proximal noise from the observer. 
%value=stimOri+randn(size(stimOri))*sqrt(var_prox);


clear estimate;
estimate_initial_time_point = 0;%define value for first Xhat
estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;
gain = 0.5;%distal / (distal +proximal);
estgain = 0.1;

err(1) = 0;
RO(1)  = 0;
estimateUpdate(1) = 0;
sdEstimate(1) = 0;

for i= 2:length (stimOri);
    
    estimate(i)=estimate(i-1);
    
    estimate(i)=estimate(i-1) + gain*(stimOri(i)-estimate(i-1));
    
    sdEstimate(i)  = stimOri(i-1) + estgain*minAngleDiff(stimOri(i),stimOri(i-1));
    
    %estimate(i) = wrapTo90(estimate(i));
    
    err(i) = minAngleDiff(estimate(i), stimOri(i));%whitney
    
    RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
    
    PE(i) = minAngleDiff(stimOri(i),estimate (i-1));%PE
    
    estimateUpdate(i) =  minAngleDiff(estimate(i),estimate (i-1));
    
    sdErr(i) = minAngleDiff(sdEstimate (i), stimOri(i));%whitney
     
    
end

[R,P]=corrcoef(err,RO);

p=polyfit(sdErr,RO,1);




figure(101);
clf;
set (gca,'fontsize', 26) %'XTickLabel',{'10','20','-30','40','50','60','70'});

hold on
%kalman track figure
plot (stimOri,'r', 'Linewidth',4);
hold on
plot (estimate,'k','Linewidth',4);
hold on
plot(sdEstimate,'g','LineWidth', 4);

axis([0,30 0, 330]);

legend ('Flight of ball', 'Kalman prediction', 'Estimate');
xlabel('Time in tenths of a second');
ylabel ('Height of ball from ground (cm)');
% 

figure(102);
%whitney figure
clf;
set(gca,'fontsize', 25);
hold on
scatter (RO, err, 200,'k','filled');
axis([-60,60,-60,60]);
xlabel('Relative Orientation of current compared to previous trial(deg) ');
ylabel('Error on current trial (deg)');

figure (103);
%precition error to RO figure
clf;
set (gca,'fontsize', 22);
hold on
scatter (RO, PE,200,'k','filled');
axis([-60,60,-60,60]);
legend ('Serial dependence');
xlabel ('RO');
ylabel('error made in prediction of position');


figure (104);
clf;
%response update figure
set (gca,'fontsize', 25);
hold on
scatter (estimateUpdate,PE,200,'b','filled');
axis([0,300 0, 300]);
legend (' Prediction Update');
xlabel('How much the kalman updates (cms)');
ylabel ('Amount of prediction error(cms)');
% 


figure(105);
%standard error figure
clf;
set(gca,'fontsize', 28) % 'XTickLabel',{'-100','-90','-80','-70','-60','-50','-40', '30', '-20', '-10', '0','10','20','30','40','50','60','70', '80', '90', '100'},  'YTickLabel',{'-50', '-40', '-30', '-20', '-10', '0', '10', '20', '30', '40', '50'});
hold on
scatter (RO, sdErr,200,'r','filled');
axis([-60,60,-60,60]);
%legend ('Positive values on the abscissa indicate that the previous trial was more clockwise than the present trial, and positive errors indicate that the reported orientation was more clockwise?')
xlabel('Relative Orientation of current compared to previous trial(deg) ');
ylabel('Error on current trial (deg)');


