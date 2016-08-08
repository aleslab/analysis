cd /Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data %lab mac
%cd C:\Users\aril\Documents\Data %lilac room

currDir = '/Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data/';
participantCode = 'AL';
currCondition = 'driftGrating_fast';
condAndParticipant = strcat(currCondition, '_', participantCode);

fileDir = strcat(currDir, condAndParticipant, '_*');
filenames = dir(fileDir);
filenames = {filenames.name}; %makes a cell of filenames from the same
%participant and condition to be loaded together

for i = 1:length(filenames)
    filenamestr = char(filenames(i));
    dataFile(i) = load(filenamestr); %loads all of the files to be analysed together
end

allExperimentData = [dataFile.experimentData]; %all of the experiment data in one combined struct
allSessionInfo = dataFile.sessionInfo; %all of the session info data in one combined struct
ResponseTable = struct2table(allExperimentData); %The data struct is converted to a table

%excluding invalid trials
wantedData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
validIsResponseCorrect = ResponseTable.isResponseCorrect(wantedData); %finding the correct responses excluding invalid responses
validCondNumber = ResponseTable.condNumber(wantedData); %finding the condition number of the valid responses
if iscell(validIsResponseCorrect) %if this is a cell because there were invalid responses
    correctResponsesArray = cell2mat(validIsResponseCorrect); %convert to an array
    correctResponsesLogical = logical(correctResponsesArray); %then convert to a logical
else
    correctResponsesLogical = logical(validIsResponseCorrect); %immediately convert to a logical
end

%Calculating the number of correct responses for each condition for the
%valid trials
correctTrials = validCondNumber(correctResponsesLogical); %the conditions of each individual correct response
correctTrialConditions = unique(correctTrials); %the conditions for which a correct response was made
condCorrectNumbers = histc(correctTrials, correctTrialConditions); %the total number of correct responses for each condition

% %Finding the total number of trials for each condition for the valid trials
allTrialConditions = unique(validCondNumber); %the conditions for which any response was made
allTrialNumbers = histc(validCondNumber, allTrialConditions); %the total number of responses for each condition
allCorrectPercentages = (condCorrectNumbers./allTrialNumbers); %creates a double of the percentage correct responses for every condition
%finding the confidence intervals
[phat, pci] = binofit(condCorrectNumbers, allTrialNumbers); %want pci (confidence intervals) for error bars

depthLowerCI = pci(1:7,1); %the lower confidence intervals for the depth trials
depthUpperCI = pci(1:7,2); %the upper confidence intervals for the depth trials

depthLowerErrorBars = allCorrectPercentages - depthLowerCI;
depthUpperErrorBars = depthUpperCI - allCorrectPercentages;

%finding the difference between the speeds used in the two sections - to be
%plotted on the graph
condInfo = allSessionInfo.conditionInfo;
if isfield(condInfo, 'velocityCmPerSecSection1');
    conditionV1s = [condInfo.velocityCmPerSecSection1];
    conditionV2s = [condInfo.velocityCmPerSecSection2];
    speedDiff = conditionV2s - conditionV1s;
    
elseif isfield(condInfo, 'velocityCmPerSecSection1') && any(condInfo.velocityCmPerSecSection1 < 0);
    flippedConditionV1s = [condInfo.velocityCmPerSecSection1].*-1;
    flippedConditionV2s = [condInfo.velocityCmPerSecSection2].*-1;
    speedDiff = flippedConditionV2s - flippedConditionV1s;
    
elseif isfield(condInfo, 'L1velocityCmPerSecSection1'); 
    %TO BE AWARE -- This section is only relevant for the CRS depth 
    %experiments. These are currently values for cm/s on the screen, not
    %values for cm/s in the world like the other conditions. 
    %I still need to do this conversion, and then will need to include it here.
    L1section1 = [condInfo.L1velocityCmPerSecSection1];
    L1section2 = [condInfo.L1velocityCmPerSecSection2];
    L2section1 = [condInfo.L2velocityCmPerSecSection1];
    L2section2 = [condInfo.L2velocityCmPerSecSection2];
    
    L1change = L1section2 - L1section1;
    L2change = L2section2 - L2section1;
    speedDiff = (L1change + L2change)./2;
    
end


%% Drawing the graph
figure;
errorbar(speedDiff, allCorrectPercentages, depthLowerErrorBars, depthUpperErrorBars, '-xk');
%plot the graph of all conditions with upper and lower confidence intervals as error bars
axis([min(speedDiff) max(speedDiff) 0 1]);
set(gca, 'Xtick', speedDiff);
set(gca, 'Ytick', 0:0.1:1);
set(gca, 'YTickLabel', 0:10:100);
set(gca,'FontSize',16);
xlabel('Difference in speed between sections (cm/s)');
ylabel('Percentage correct responses');
title(condAndParticipant, 'interpreter', 'none');

%% export to an excel file

excelFileName = strcat(condAndParticipant, '.csv');
writetable(ResponseTable, excelFileName);
