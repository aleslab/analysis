function [sortedTrialData] = organizeData(sessionInfo,experimentData)
% ORGANIZEDATA This function organizes an experiment session 
%
% [sortedTrialData] = organizeData(sessionInfo,experimentData)
%
%  This function takes an experimental session and collects
%  all the repetitions of a condition together
%
%  Output:
%  sortedTrialData  = sortedTrialData(nConditions).trialData(nRepetitions)
%  The output is a multilevel structure with the first level collecting all
%  the different conditions. This contains the trialData for each
%  repition. The nested structure allows for different condition types and
%  repition numbers.
%                 

nCond = length(sessionInfo.conditionInfo);

repsPerCond = zeros(nCond,1); %Keep track of the repetitions per condition

for iTrial = 1:length(experimentData),

    if ~experimentData(iTrial).validTrial
        continue
    end
    
thisCond = experimentData(iTrial).condNumber;
%Increment the reps by 1; 
repsPerCond(thisCond) = repsPerCond(thisCond) + 1; 
thisRep  = repsPerCond(thisCond);

thisTrialData = experimentData(iTrial).trialData;
thisTrialData.condNumber = thisCond;
sortedTrialData(thisCond).trialData(thisRep) = thisTrialData;

end






