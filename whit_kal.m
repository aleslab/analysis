
%clc;
clear all;

%value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = actual stim ori

stimOri = wrapTo90(360*rand(200,1));

%This line is to simulate proximal noise from the observer. 
%value=(stimOri+randn(size(stimOri))*sqrt(var_prox));
value = stimOri;

p_response = stimOri;%(respOri);
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

gain = 0.9;%var_dist / (var_dist + var_prox);
%estimate = estimate+gain*value - estimate;

err(1) = 0;
RO(1)  = 0;
for i= 2:length (value);
    %estimate(i)=estimate(i-1);

    estimate(i)=estimate(i-1) + gain*minAngleDiff(value(i),estimate(i-1));
    estimate(i) = wrapTo90(estimate(i));
    %gain(i)=(1-gain*(distal(i)));
    
     err(i) = minAngleDiff(estimate(i), stimOri(i));
     RO(i)=  minAngleDiff (stimOri(i-1),stimOri(i));
    
end

[R,P]=corrcoef(err,RO);


figure(101);
clf;
plot (p_response,'.');

hold on
plot (value, 'bx');
plot (estimate, 'c*');
legend ('p_response', 'actual_stimOri', 'modelled kalman resposne given calibrated gain')
%legend('Stim movement', 'how the kalman tracks stim', 'how partcipant tracks ') 
% 






% plot(Z,'m')
% hold on;
% plot(Xhat,'c')
% plot(B, 'k')
% legend('Stim movement', 'how the kalman tracks stim', 'how partcipant tracks ') 
% 
% grid on
 

figure(102);clf;
scatter (RO, err);


