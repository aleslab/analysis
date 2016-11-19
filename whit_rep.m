

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond =1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];



    for i=  2:length(respOri);
        
        
       
        err(i) = minAngleDiff(respOri(i), stimOri(i));
        RO(i)=  minAngleDiff(respOri(i-1), respOri(i));
       % RO(i) = minAngleDiff(stimOri(i-1), stimOri(i));
        
    end 
         

data=respOri; %calculation to get standard error of the mean for the amount of error between
sem=std(data)/sqrt(length(data));% stimOri and respOri
std(err)

var_prox=var(err); % amount of variance in the error
var_dist=var(stimOri); %variance in the stimOri
gain=var_dist / (var_dist + var_prox);
%resp_time=(sortedData(3).trialData.responseTime); % mean response times for each con
%MT=mean(resp_time);% NEED TO CHANGE THE NUMBER OF SORTED DATA EACH TIME YOU RUN
% FOR EXAMPLE sortedData(?) to match the condition number

%cor=(corrcoef(respOri(i),stimOri(i-1));


       figure; % RESIDUAL ERROR PLOT.
       scatter (RO, err);
       
       
xlabel('relative orientation of previous trial'); % x-axis label
ylabel('error on current trial (deg)'); % y-axis label


% figure
%        plot (var_dist, 'r');
%        hold on
%        plot (var_prox, 'g');
%        hold on 
%        plot (gain, 'b');
%        


% filename={'P1_whit_com.mat'};
% save('P1_whit_com.mat');
% 

    





    

    




