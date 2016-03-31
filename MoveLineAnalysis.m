cd /Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data
%cd C:\Users\aril\Documents\Data

%Eventually want it so that you can specify the initials and the conditions
%to load from within the piece of code.

% condition = {'combined_towards'};
% subjectInitials = {'ALp'};
% fileNameString = strcat('MoveLine_', condition, '_', subjectInitials,'_');
% fileNameStart = char(fileNameString);

%filenames = dir('C:\Users\aril\Documents\Data\MoveLine_combined_towards_ALp*'); %for the lilac room
filenames = dir('/Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data/MoveLine_combined_towards_ALp*'); %for the lab mac
%will load all AL pilots in the combined towards paradigm
filenames = {filenames.name}; %makes a cell of filenames
i = 1;
for i = 1:length(filenames)
    filenamestr = char(filenames(i));
    dataFile(i) = load(filenamestr); 
    i = i+1;
    %creates a struct with the data from each loaded file, so that data 
    %from different blocks of the same condition can be loaded to be analysed together.
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
%allTrials = validCondNumber;
allTrialConditions = unique(validCondNumber); %the conditions for which any response was made
allTrialNumbers = histc(validCondNumber, allTrialConditions); %the total number of responses for each condition

allCorrectPercentages = (condCorrectNumbers./allTrialNumbers)*100; %creates a double of the percentage correct responses for every condition

if length(allTrialNumbers) > 7 %if there's more than 7 conditions because there's both lateral and depth presentations
allDepthPercentageCorrect = allCorrectPercentages(1:7);
allLateralPercentageCorrect = allCorrectPercentages(8:14);
else
    allDepthPercentageCorrect = allCorrectPercentages;
end

conditionFirstSectionVelocities = [allSessionInfo.conditionInfo.velocityCmPerSecSection1]; %looking at the initial speed of the movement of the line to plot on the graph
FirstVelocities = unique(conditionFirstSectionVelocities); %we don't want the entire matrix of hundreds of the same speeds over and over again, just want to know the speeds, so use unique.
%get rid of negative sign as it doesn't matter which direction the condition was here.
if min(FirstVelocities) < 0;
    normalisedFirstVelocities = FirstVelocities*-1;
    orderedVelocities = fliplr(normalisedFirstVelocities);
else
    normalisedFirstVelocities = FirstVelocities;
    orderedVelocities = normalisedFirstVelocities;
end


%Drawing the graph of percentage "the condition was faster" responses for
%depth conditions
figure
plot(orderedVelocities, allDepthPercentageCorrect, '-xk');
axis([min(orderedVelocities) max(orderedVelocities) 0 100]);
set(gca, 'Xtick', (min(orderedVelocities)):2.5:(max(orderedVelocities)));
xlabel('Velocity of the first section (cm/s)');
ylabel('Percentage correct responses');
title('towards');

if length(allTrialNumbers) > 7 %if there were lateral conditions, drawing a second graph for those conditions
figure
plot(orderedVelocities, allLateralPercentageCorrect, '-xk');
axis([min(orderedVelocities) max(orderedVelocities) 0 100]);
set(gca, 'Xtick', (min(orderedVelocities)):2.5:(max(orderedVelocities)));
xlabel('Velocity of the first section (cm/s)');
ylabel('Percentage correct responses');
title('lateral');
end
