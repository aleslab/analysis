

fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);


iCond =2; %When you have only 1 condition % 
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri]; % when we have 3 cons


% respOri = [sortedData.trialData(:).respOri];% when we have one condition
% stimOri = [sortedData.trialData(:).stimOri];



    for i=  2:length(respOri);
        
        
       
        err(i) = minAngleDiff(respOri(i), stimOri(i));
        %RO(i)=  minAngleDiff (respOri(i-1),respOri (i));
        RO(i) = minAngleDiff(stimOri(i-1), stimOri(i));
        
    end 
    
    
         

data=respOri; %calculation to get standard error of the mean for the amount of error between
sem=std(data)/sqrt(length(data));% stimOri and respOri
std(err)

var_prox=var(err); % amount of variance in the error
var_dist=var(stimOri); %variance in the stimOri
gain=var_dist / (var_dist + var_prox);


%[r,p]=corrcoef(err,RO);

       figure; % RESIDUAL ERROR PLOT.
       scatter (RO, err);
       
       
xlabel('relative orientation of previous trial'); % x-axis label
ylabel('error on current trial (deg)'); % y-axis label




    





    

    




