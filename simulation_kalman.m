%clc;
clear all;

value = [20 60 120 200 280 320 360 300 210 180 130 90 60 20]; % value = actual stim ori
respOri = [ 25 65 125 270 310 350 280 240 200 100 80 50 10 10];

stimOri = value;

p_response = respOri;
clear estimate;


estimate_initial_time_point = 0;%define value for first Xhat

estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;

gain = 0.99;


err(1) = 0;
RO(1)  = 0;
PE(1) = 0;
value(1) = 0;
respOri(1) = 1;
for i= 2:length (value);
   
    estimate(i)=estimate(i-1) + gain*minAngleDiff(value(i),estimate(i-1));
    
    
    estimate(i) = wrapTo90(estimate(i));
    
    %estimate (i) = estimate (i-1) + gain * (value(i) - estimate (i-1));
    %estimate (i)= estimate(i);
    err(i) = minAngleDiff(respOri(i), stimOri(i));
    RO(i)=  minAngleDiff (respOri(i-1),respOri (i));
    
    PE(i) = minAngleDiff(stimOri(i),respOri(i-1));
    
    
end

figure(101);
clf;
plot (p_response,'r');

hold on
plot (stimOri, 'bx');
plot (estimate, 'c*');
legend ('p_response', 'actual_stimOri', 'modelled kalman resposne given calibrated gain')


figure(102);clf;
scatter (RO, err);
legend ('whitney')


figure (103);clf
plot (stimOri);
hold on
plot (PE);
legend ('Prediction error');

