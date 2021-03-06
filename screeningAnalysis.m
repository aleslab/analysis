clearvars;
cd /Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data %lab mac

load('');

ResponseTable = struct2table(experimentData);
wantedData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
validIsResponseCorrect = ResponseTable.isResponseCorrect(wantedData); %
validCondNumber = ResponseTable.condNumber(wantedData);
if iscell(validIsResponseCorrect) %if this is a cell because there were invalid responses
    correctResponsesArray = cell2mat(validIsResponseCorrect); %convert to an array
    correctResponsesLogical = logical(correctResponsesArray); %then convert to a logical
else
    correctResponsesLogical = logical(validIsResponseCorrect); %immediately convert to a logical
end

    correctTrials = validCondNumber(correctResponsesLogical); %the conditions of each individual correct response
    correctTrialConditions = unique(correctTrials); %the conditions for which a correct response was made
    condCorrectNumbers = histc(correctTrials, correctTrialConditions); %the total number of correct responses for each condition
    condCorrectNumbers = condCorrectNumbers';
    % %Finding the total number of trials for each condition for the valid trials
    allTrialConditions = unique(validCondNumber); %the conditions for which any response was made
    allTrialNumbers = histc(validCondNumber, allTrialConditions); %the total number of responses for each condition
    allTrialNumbers = allTrialNumbers';
    
    allCorrectPercentages = (condCorrectNumbers./allTrialNumbers)*100; %creates a double of the percentage correct responses for every condition
    
    level3message = strcat('Percentage correct for level 3 is: ', num2str(allCorrectPercentages(1)), '%'); %+/- 2cm/s, 4cm/s change
    level7message = strcat('Percentage correct for level 7 is: ', num2str(allCorrectPercentages(2)), '%'); %+/- 6cm/s, 12cm/s change
    
    disp(level3message);
    disp(level7message);
    