
clc;


%value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = actual stim ori


value=(stimOri);
p_response = (respOri);
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
distal = var_dist;
proximal = var_prox;

% var_prox=var(err); % amount of variance in the error
% var_dist=var(stimOri); %variance in the stimOri
% gain=var_dist / (var_dist + var_prox);

gain = .99999;distal / (distal +proximal);
%estimate = estimate+gain*value - estimate;

err(1) = 0;
RO(1)  = 0;
for i= 2:length (value);
    estimate(i)=estimate(i-1);

    estimate(i)=estimate(i-1) + gain*(value(i)-estimate(i));
    %gain(i)=(1-gain*(distal(i)));
    
     err(i) = minAngleDiff(estimate(i), value(i));
     RO(i)=  minAngleDiff (value(i-1),value(i));
  
    
end

%plot (value);

% plot (gain, 'r');
% hold on


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
 

figure;
scatter (RO, err);
    