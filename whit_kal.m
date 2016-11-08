

% fileToLoad = uigetfile; load(fileToLoad);
% [sortedData] = organizeData(sessionInfo,experimentData);
% 
% 
% iCond =2; %When you have only 1 condition
% Z = [sortedData(iCond).trialData(:).respOri];
% B = [sortedData(iCond).trialData(:).stimOri];


%27014471509;-57.3335435238649;-51.1634861330904;-150.364066752811;-47.8948887608929;27.1291776387804;137.057547347594;-140.530117657153;-36.5066023797064];
%Z=[0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45];
%B= [ 0.45 0.53 0. 53 0.38 0.25 0.38 0.50 0.46 0.49];

Xinitial_time_point=0;
Pinitial=9;
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
    K(k)=P(k)/(P(k)+R);%measurement update
    Xhat(k)=Xhat(k)+ K(k)*(Z(k)-Xhat(k));
    P(k)=P(k);%(1-K(k))*P(k);
   
end
plot(Z,'m')
hold on;
plot(Xhat,'c')
plot(B, 'k')
legend('Stim movement', 'how the kalman tracks stim', 'how partcipant tracks ') 

grid on
 


    