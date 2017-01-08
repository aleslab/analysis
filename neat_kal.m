

% fileToLoad = uigetfile; load(fileToLoad);
% [sortedData] = organizeData(sessionInfo,experimentData);


%iCond =2; %When you have only 1 condition
% B = [sortedData(iCond).trialData(:).respOri];
% Z = [sortedData(iCond).trialData(:).stimOri];

Z=360*rand(20,1);
B=Z+rand(20,1);
Xinitial_time_point=0;
Pinitial=1;
R = 1;
Xhat = [];
Xhat(1)=Xinitial_time_point;
P(1)=Pinitial;
K(1)=P(1)/(P(1)+R);
Xhat (1)= Xhat(1)+ K(1)*(Z(1)-Xhat(1));
P(1)=(1-K(1))*P(1);
for k=2:length(Z), 
    Xhat(k)=Xhat(k-1);
    %P(k)=P(k-1);
    K(k)=0.43;%gain
    Xhat(k)=Xhat(k)+ K(k)*(Z(k)-Xhat(k));
    %P(k)=P(k);%(1-K(k))*P(k);
    
    
   estimateUpdate(k) =  (Xhat(k)-Xhat (k-1));
   PE(k) = (Z(k)- Xhat(k-1));%PE
end
figure (101)
clf
set (gca,'fontsize', 22);
hold on
plot(Z,'r','Linewidth', 3);
hold on;
plot(Xhat,'k', 'Linewidth', 3);
legend('Actual blade orientation','Kalman prediction');

xlabel('Time recorded');
ylabel ('Orientation of blades in degrees');

figure (102);
clf;
set (gca,'fontsize', 22);
hold on

scatter (estimateUpdate, PE, 200,'k','filled'); 
%set(estimateUpdate,'SizeData',20);
hold on
legend ('Prediction update in degrees');
xlabel('Prediction updates in degrees');
ylabel ('Prediction error in degrees');


    