

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond =2; %When you have only 1 condition
B = [sortedData(iCond).trialData(:).respOri];
Z = [sortedData(iCond).trialData(:).stimOri];

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
    P(k)=P(k-1);
    K(k)=0.90;%measurement update
    Xhat(k)=Xhat(k)+ K(k)*(Z(k)-Xhat(k));
    P(k)=P(k);%(1-K(k))*P(k);
   
end
plot(Z,'m')
hold on;
plot(Xhat,'c')
plot(B, 'k')
legend('Stim movement', 'how the kalman tracks stim', 'how partcipant tracks ') 

grid on
 


    