

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond = 2; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];



    for i=  2:length(respOri);
        
        
       
        err(i) = minAngleDiff(respOri(i), stimOri(i));
        RO(i) = minAngleDiff(stimOri(i-1), stimOri(i));

         
    end 
         

data=respOri; %calculation to get standard error of the mean for the amount of error between
sem=std(data)/sqrt(length(data));% stimOri and respOri
std(err)

Var_err=var(err); % amount of variance in the error

resp_time=(sortedData(2).trialData.responseTime); % mean response times for each con
MT=mean(resp_time);% NEED TO CHANGE THE NUMBER OF SORTED DATA EACH TIME YOU RUN
% FOR EXAMPLE sortedData(?) 


       figure; % RESIDUAL ERROR PLOT.
       scatter (RO, err);
       
       
       
xlabel('relative orientation of previous trial'); % x-axis label
ylabel('error on current trial (deg)'); % y-axis label




    





    

    




