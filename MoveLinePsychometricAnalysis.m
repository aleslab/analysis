clearvars;
cd /Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data %lab mac

currDir = '/Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data/';
participantCode = 'AL';
conditionList = {'driftGrating_fast'; 'MoveLine_CRS_lateral_fast';  ...
    'MoveLine_accelerating_depth_midspeed'; 'MoveLine_accelerating_depth_slow'; ... 
    'MoveLine_accelerating_lateral_midspeed'; 'MoveLine_accelerating_lateral_slow'; ... 
    'MoveLine_CRS_depth_midspeed'; 'MoveLine_CRS_depth_slow'; ... 
    'MoveLine_CRS_lateral_midspeed'; 'MoveLine_CRS_lateral_slow'};

for i = 1:length(conditionList)
currCondition = conditionList(i);

condAndParticipant = strcat(currCondition, '_', participantCode);

fileDir = cell2mat(strcat(currDir, condAndParticipant, '_*'));
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

message = 'Parametric Bootstrap (1) or Non-Parametric Bootstrap? (2): ';
ParOrNonPar = input(message);

%excluding invalid trials
wantedData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
validIsResponseCorrect = ResponseTable.isResponseCorrect(wantedData); %
validCondNumber = ResponseTable.condNumber(wantedData);
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
condCorrectNumbers = condCorrectNumbers';
% %Finding the total number of trials for each condition for the valid trials
allTrialConditions = unique(validCondNumber); %the conditions for which any response was made
allTrialNumbers = histc(validCondNumber, allTrialConditions); %the total number of responses for each condition
allTrialNumbers = allTrialNumbers';
%allCorrectPercentages = (condCorrectNumbers./allTrialNumbers); %creates a double of the percentage correct responses for every condition

%finding the difference between the speeds used in the two sections - to be
%plotted on the graph
condInfo = allSessionInfo.conditionInfo;
if isfield(condInfo, 'lateralCmPerSecS1lower');
    
    averageS1speed = ([condInfo.lateralCmPerSecS1lower] + [condInfo.lateralCmPerSecS1upper])./2;
    averageS2speed = ([condInfo.lateralCmPerSecS2lower] + [condInfo.lateralCmPerSecS2upper])./2;
    speedDiff = averageS2speed - averageS1speed;
    
elseif isfield(condInfo, 'velocityCmPerSecSection1');
    conditionV1s = [condInfo.velocityCmPerSecSection1];
    conditionV2s = [condInfo.velocityCmPerSecSection2];
    speedDiff = conditionV2s - conditionV1s;
    
    if [condInfo.velocityCmPerSecSection1] < 0;
        flippedConditionV1s = [condInfo.velocityCmPerSecSection1].*-1;
        flippedConditionV2s = [condInfo.velocityCmPerSecSection2].*-1;
        speedDiff = flippedConditionV2s - flippedConditionV1s;
    end
    
elseif isfield(condInfo, 'depthSpeedSection1');
    
  speedDiff =  [condInfo.depthSpeedSection2] - [condInfo.depthSpeedSection1];
    
end
%% Psychometric function fitting adapted from PAL_PFML_Demo

tic

PF = @PAL_CumulativeNormal;

%Threshold and Slope are free parameters, guess and lapse rate are fixed
paramsFree = [1 1 0 0];  %1: free parameter, 0: fixed parameter

%Parameter grid defining parameter space through which to perform a
%brute-force search for values to be used as initial guesses in iterative
%parameter search.
searchGrid.alpha = [min(speedDiff):0.01:max(speedDiff)];
searchGrid.beta = logspace(0,3,101);
searchGrid.gamma = 0.5;  %scalar here (since fixed) but may be vector
searchGrid.lambda = 0.03;  %ditto

%Perform fit
disp('Fitting function.....');
[paramsValues, LL, exitflag] = PAL_PFML_Fit(speedDiff,condCorrectNumbers, ...
    allTrialNumbers,searchGrid,paramsFree,PF);

disp('done:')
message = sprintf('Threshold estimate: %6.4f',paramsValues(1));
disp(message);
message = sprintf('Slope estimate: %6.4f\r',paramsValues(2));
disp(message);

%Number of simulations to perform to determine standard error
B=400;

disp('Determining standard errors.....');

if ParOrNonPar == 1
    [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapParametric(...
        speedDiff, allTrialNumbers, paramsValues, paramsFree, B, PF, ...
        'searchGrid', searchGrid);
else
    [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapNonParametric(...
        speedDiff, condCorrectNumbers, allTrialNumbers, [], paramsFree, B, PF,...
        'searchGrid',searchGrid);
end

disp('done:');
message = sprintf('Standard error of Threshold: %6.4f',SD(1));
disp(message);
message = sprintf('Standard error of Slope: %6.4f\r',SD(2));
disp(message);

%Number of simulations to perform to determine Goodness-of-Fit
B=1000;

disp('Determining Goodness-of-fit.....');

[Dev, pDev] = PAL_PFML_GoodnessOfFit(speedDiff, condCorrectNumbers, allTrialNumbers, ...
    paramsValues, paramsFree, B, PF, 'searchGrid', searchGrid);

disp('done:');

%Put summary of results on screen
message = sprintf('Deviance: %6.4f',Dev);
disp(message);
message = sprintf('p-value: %6.4f',pDev);
disp(message);

%Create simple plot
ProportionCorrectObserved=condCorrectNumbers./allTrialNumbers;
StimLevelsFineGrain=[min(speedDiff):max(speedDiff)./1000:max(speedDiff)];
ProportionCorrectModel = PF(paramsValues,StimLevelsFineGrain);

figure;
axes
hold on
plot(StimLevelsFineGrain,ProportionCorrectModel,'-','color',[0 .7 0],'linewidth',4);
plot(speedDiff,ProportionCorrectObserved,'-k.','markersize',40);
set(gca, 'fontsize',16);
set(gca, 'Xtick', speedDiff);
axis([min(speedDiff) max(speedDiff) .4 1]);
xlabel('Difference in speed between sections (cm/s)');
ylabel('proportion correct');
title(condAndParticipant, 'interpreter', 'none');

saveas(gcf, condAndParticipant, 'pdf');

toc
end