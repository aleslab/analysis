cd /Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data %lab mac
%cd C:\Users\aril\Documents\Data %lilac room

%Eventually want it so that you can specify the initials and the conditions
%to load from within the piece of code.

%filenames = dir('C:\Users\aril\Documents\Data\MoveLine_cd_towards_ALnew*'); %for the lilac room
filenames = dir('/Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data/driftGrating_fast__*'); %for the lab mac
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

allCorrectPercentages = (condCorrectNumbers./allTrialNumbers); %creates a double of the percentage correct responses for every condition
[phat, pci] = binofit(condCorrectNumbers, allTrialNumbers); %want pci (confidence intervals) for error bars 
if length(allTrialNumbers) > 7 %if there's more than 7 conditions because there's both lateral and depth presentations
allDepthPercentageCorrect = allCorrectPercentages(1:7);
allLateralPercentageCorrect = allCorrectPercentages(8:14);
depthPCI = pci(1:7,:); %takes the confidence interval for the first 7 conditions (depth) calculated by the binofit
lateralPCI = pci(8:14,:); %takes the confidence interval for the lateral (last 7) conditions calculated by the binofit
depthLowerCI = depthPCI(1:7,1); %the lower confidence intervals for the depth trials
depthUpperCI = depthPCI(1:7,2); %the upper confidence intervals for the depth trials
lateralLowerCI = lateralPCI(1:7,1); %the lower confidence intervals for the lateral trials
lateralUpperCI = lateralPCI(1:7,2); %the upper confidence intervals for the lateral trials

depthLowerErrorBars = allDepthPercentageCorrect - depthLowerCI; 
depthUpperErrorBars = depthUpperCI - allDepthPercentageCorrect;
lateralLowerErrorBars = allLateralPercentageCorrect - lateralLowerCI; 
lateralUpperErrorBars = lateralUpperCI - allLateralPercentageCorrect;
%the size of the error bars to plot around the points to indicate the confidence bounds

else
    allDepthPercentageCorrect = allCorrectPercentages;
    depthPCI = pci;
    depthLowerCI = depthPCI(1:7,1); %the lower confidence intervals for the depth trials
    depthUpperCI = depthPCI(1:7,2); %the upper confidence intervals for the depth trials
    
    depthLowerErrorBars = allDepthPercentageCorrect - depthLowerCI; 
    depthUpperErrorBars = depthUpperCI - allDepthPercentageCorrect;
end

conditionFirstSectionVelocities = [allSessionInfo.conditionInfo.velocityCmPerSecSection1]; %looking at the initial speed of the movement of the line to plot on the graph
FirstVelocities = unique(conditionFirstSectionVelocities); %we don't want the entire matrix of hundreds of the same speeds over and over again, just want to know the speeds, so use unique.
%get rid of negative sign as it doesn't matter which direction the condition was here.
flippedSpeed = true; %the slow section is at the beginning rather than at the end
if flippedSpeed == true
    normalisedFirstVelocities = FirstVelocities;
    orderedVelocities = normalisedFirstVelocities;
    
elseif min(FirstVelocities) < 0
    normalisedFirstVelocities = FirstVelocities*-1;
    orderedVelocities = fliplr(normalisedFirstVelocities);
else
    normalisedFirstVelocities = FirstVelocities;
    orderedVelocities = normalisedFirstVelocities;
end
%This section is basically here so that the axes aren't weird when you flip
%the speed orders around as it was drawing the graphs backwards.

%% Drawing the graphs

%Drawing the graph of percentage correct responses for
%depth conditions
figure(101); %hold on;
%plot(orderedVelocities, allDepthPercentageCorrect, '-xk');
errorbar([0 1 2 3 4 5 6], allDepthPercentageCorrect, depthLowerErrorBars, depthUpperErrorBars, '-xk');
%plot the graph of depth conditions with upper and lower confidence intervals as error bars
axis([0 6 0 1]);
set(gca, 'Xtick', [0:1:6]);
set(gca, 'Ytick', 0:0.1:1);
set(gca, 'YTickLabel', 0:10:100);
set(gca,'FontSize',20);
xlabel('+/- Speed change relative to standard (cm/s)');
ylabel('Percentage correct responses');
%title('depth');
% 
% %lateral conditions
% if length(allTrialNumbers) > 7 %if there were lateral conditions, drawing a second graph for those conditions
% figure(102); %hold on;
% %plot(orderedVelocities, allLateralPercentageCorrect, '-xk');
% errorbar(orderedVelocities, allLateralPercentageCorrect, lateralLowerErrorBars, lateralUpperErrorBars, '-xk');
% %plot the graph of the lateral conditions with upper and lower confidence intervals as error bars
% axis([min(orderedVelocities) max(orderedVelocities) 0 1]);
% set(gca, 'Xtick', (min(orderedVelocities)):2.5:(max(orderedVelocities)));
% set(gca, 'Ytick', 0:0.1:1);
% set(gca, 'YTickLabel', 0:10:100);
% set(gca,'FontSize',20);
% xlabel('Velocity of the first section (cm/s)');
% ylabel('Percentage correct responses');
% title('lateral');
% end

%% export to an excel file

% excelFileName = 'MoveLine_cd_towards__slow_fast.csv';
% writetable(ResponseTable, excelFileName);
