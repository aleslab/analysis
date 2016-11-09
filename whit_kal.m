

value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = est

% fileToLoad = uigetfile; load(fileToLoad);
% [sortedData] = organizeData(sessionInfo,experimentData);
% 
% 
% iCond =2; %When you have only 1 condition
% respOri = [sortedData(iCond).trialData(:).respOri];
% stimOri = [sortedData(iCond).trialData(:).stimOri];

estimate_initial_time_point = 0;%define value for first Xhat

estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;
distal = 100;
proximal = 120;

% var_prox=var(err); % amount of variance in the error
% var_dist=var(stimOri); %variance in the stimOri
% gain=var_dist / (var_dist + var_prox);

gain = distal / (distal +proximal);
estimate = estimate+gain*value - estimate;


for i= 1:length (value);
    estimate(i)=estimate(i-1);
    gain(i) =  (i-1)/ (distal(i)+proximal(i-1));
    estimate(i)=estimate(i-1) + gain(i)*(value(i)-estimate(i));
    gain(i)=(1-gain(i)*(distal(i)));
    
end

plot (value);
hold on
% plot (gain, 'r');
% hold on
plot (estimate);
hold off

grid on










% plot(Z,'m')
% hold on;
% plot(Xhat,'c')
% plot(B, 'k')
% legend('Stim movement', 'how the kalman tracks stim', 'how partcipant tracks ') 
% 
% grid on
 


    