
stimOri = [20 60 120 200 280 320 360 300 210 180 130 90 60 20]; % value = actual stim ori
respOri = [ 25 65 125 270 310 350 280 240 200 100 80 50 10 10];



    for i=  2:length(respOri);
        
        
       
        err(i) = minAngleDiff(respOri(i), stimOri(i));
        RO(i)=  minAngleDiff (respOri(i-1),respOri (i));
       % RO(i) = minAngleDiff(stimOri(i-1), stimOri(i));
        
    end 
         

data=respOri; %calculation to get standard error of the mean for the amount of error between
sem=std(data)/sqrt(length(data));% stimOri and respOri
std(err)

var_prox=var(err); % amount of variance in the error
var_dist=var(stimOri); %variance in the stimOri
gain=var_dist / (var_dist + var_prox);


[R,P]=corrcoef(err,RO);

       figure; % RESIDUAL ERROR PLOT.
       scatter (RO, err);
       
       
xlabel('relative orientation of previous trial'); % x-axis label
ylabel('error on current trial (deg)'); % y-axis label




    





    

    




