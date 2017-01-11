

% fileToLoad = uigetfile; load(fileToLoad);
% [sortedData] = organizeData(sessionInfo,experimentData);


%iCond =2; %When you have only 1 condition
% B = [sortedData(iCond).trialData(:).respOri];
% Z = [sortedData(iCond).trialData(:).stimOri];
Z=(20*rand(30,1));

%Z=360*rand(20,1);
%B=wrapTo90(Z+rand(20,1));
Xinitial_time_point=0;
Pinitial=1;
R = 1;
Xhat = [];
Xhat(1)=Xinitial_time_point;
P(1)=Pinitial;
K(1)=P(1)/(P(1)+R);
Xhat (1)= Xhat(1)+ K(1)*minAngleDiff(Z(1),Xhat(1));
P(1)=(1-K(1))*P(1);
for k=2:length(Z), 
    Xhat(k)=Xhat(k-1);
    %P(k)=P(k-1);
    K(k)=0.9;%gain
    Xhat(k)=Xhat(k)+ K(k)*(Z(k)-Xhat(k));
    %P(k)=P(k);%(1-K(k))*P(k);
    
    RO(k)=  minAngleDiff(Z(k-1),Z (k));
    err(k) =minAngleDiff(Xhat(k)- Z(k));%whitney
    
   estimateUpdate(k) = minAngleDiff(Xhat(k),Xhat (k-1));
   PE(k) = minAngleDiff(Z(k), Xhat(k-1));%PE
end
figure (101)
clf
set (gca,'fontsize', 22);
hold on
plot(Z,'r','Linewidth', 3);
hold on;
plot(Xhat,'k', 'Linewidth', 3);
legend('Actual position','Kalman/GPS prediction');

xlabel('Time recorded');
ylabel ('Movement  of car on road');

figure (102);
clf;
set (gca,'fontsize', 22);
hold on

scatter (estimateUpdate, PE, 200,'k','filled'); 
%set(estimateUpdate,'SizeData',20);
hold on
legend ('Prediction update in meters ');
xlabel('Prediction updates in meters');
ylabel ('Prediction error in meters');

figure (103);
clf;
scatter (RO, err, 200,'k','filled'); 
legend ('error on trial');
xlabel('RO');
ylabel('error');


    