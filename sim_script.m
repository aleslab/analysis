stimOri=[0 0 0 0 0  0 0 0 0 0 50 50 50 50 50 50 50 50 50 50 0 0 0 0 0 0 0 0 0 0 ];
measure=[2 4 2 4 4  4 2 6 3 5 45 55 60 56 60 45 55 56 53 63 0 0 0 0 0 0 0 0 0 0 ];
%measure=[12 11 13 12 79 83 82 81 18 21 19 22 88 92 88 89 12 10 12 11 88 92 91 90 8  12 11 11];
% stimOri=[10 10 10 10 20 20 20 20 30 30 30 30 50 50 50 50 20 20 20 20 40 40 40 40 60 60 60 60];
% measure=[17 22 11 20 30 10 30 33 55 20 22 44 60 45 70 40 40 22 40 10 30 60 50 75 33 70 60 45];
%measure=[12 11 12 13 18 22 21 22 32 28 32 31 48 53 52 49 19 21 22 22 38 43 44 38 58 57 62 63];
estimate_initial_time_point = 0;%define value for first Xhat

kal_predict(10) = estimate_initial_time_point; % tell matlab that the first Xhat 
distal_initial_time_point = 1;

gain = .9;


part_PE_Err(1) = 0;
RO(1)  = 0;
for i= 2:length (stimOri);
    
    kal_predict(i)=kal_predict(i-1);%kalman
    
    kal_predict(i)=kal_predict(i-1) + gain*minAngleDiff(stimOri(i),kal_predict(i-1));%kalman
    
    kal_predict(i) = wrapTo90(kal_predict(i));%kalman wrap function
    
    response(i) = measure(i)*0.5+ measure (i-1)*0.5;
    
end
    
    figure (101)
    clf;
    set(gca, 'fontweight', 'bold','fontsize', 32);
    hold on
    plot(kal_predict, 'r', 'Linewidth', 16);
    hold on
    plot (stimOri, 'k', 'Linewidth', 16);
    hold on
    plot (measure, 'g', 'Linewidth', 16);
    xlabel('Time');
    ylabel ('Voltage')
    axis([0,30,-0,100]);
    
    figure (202)
    clf;
    set(gca,'fontsize', 38, 'FontWeight', 'bold');
    hold on 
    plot(response, 'r', 'Linewidth', 16);
    hold on
    plot (stimOri, 'k', 'Linewidth', 16);
    hold on
    plot (measure, 'g', 'Linewidth', 16);
    xlabel('Time','fontweight', 'bold','fontsize', 32);
    ylabel ('Voltage','fontweight', 'bold','fontsize', 32)
    axis([0,30,-0,100]);
     
    
%     
%     
%     


