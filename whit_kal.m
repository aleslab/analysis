

value = [0.39	0.50	0.48	0.29	0.25	0.32	0.34	0.48	0.41	0.45]; % value = est


estimate_initial_time_point = 0;%define value for first Xhat

estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;
distal = 100;
proximal = 120;
gain = distal_inital_time_point / (distal_initial_time_point+proximal);
estimate = estimate(1)+gain*value(1)-esimate(i);
prediction_error = value - new_estimate;

for i= 2:length (value);
    estimate(i)=estimate(i-1);
    gain(i) =  distal_initial_time_point(i)/ (distal(i)+proximal(i));
    estimate(i)=estimate(i) + gain(i)*(prediction_error(i));
    gain(i)=(1-gain(i)*(distal(i)));
    
end

plot (value, 'm');
hold on
plot (estimate, 'c');











plot(Z,'m')
hold on;
plot(Xhat,'c')
plot(B, 'k')
legend('Stim movement', 'how the kalman tracks stim', 'how partcipant tracks ') 

grid on
 


    