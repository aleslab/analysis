clc;
clear all;

%value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = actual stim ori


fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

% 
iCond =2; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);

estimate_initial_time_point = 0;%define value for first Xhat

estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;

gain = .9;%distal / (distal +proximal);
%estimate = estimate+gain*value - estimate;

err(1) = 0;
RO(1)  = 0;
for i= 2:length (respOri);
    %estimate(i)=estimate(i-1);

    estimate(i)=estimate(i-1) + gain*minAngleDiff(respOri(i),estimate(i-1));
    estimate(i) = wrapTo90(estimate(i));
    %gain(i)=(1-gain*(distal(i)));
    
     err(i) = minAngleDiff(estimate(i), stimOri(i));
     RO(i)=  minAngleDiff (stimOri(i-1),stimOri(i));
    
end
%plot (value);

% plot (gain, 'r');
% hold on


figure(101);
clf;
plot (stimOri);

hold on
plot (respOri, 'bx');
hold on
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


