cd /Users/Abigail/Documents/Experiment_Data/Experiment_9

% 5 conditions
% 1. Line Simultaneous
% 2. Line Continuous
% 3. Dot Simultaneous
% 4. Dot Continuous
% 5. Dot Continuous Alternative

participantCodes = {'AL'};

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    
    %load line simultaneous data
    
    lineSFileDir = strcat('/Users/Abigail/Documents/Experiment_Data/Experiment_9/',...
        currParticipantCode, '/movingLine_simultaneous_*');
    lineSfilenames = dir(lineSFileDir);
    lineSfilenames = {lineSfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for ilineSFiles = 1:length(lineSfilenames)
        lineSfilenamestr = char(lineSfilenames(ilineSFiles));
        lineSDataFile(ilineSFiles) = load(lineSfilenamestr); %loads all of the files to be analysed together
    end
    
    lineSExperimentData = [lineSDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = lineSDataFile.sessionInfo; %all of the session info data in one combined struct
    lineSResponseTable = struct2table(lineSExperimentData);
    
    %excluding invalid trials
    validlineSData = ~(lineSResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validlineSResponses = lineSResponseTable.response(validlineSData); %
    validlineSCondNumber = lineSResponseTable.condNumber(validlineSData);
    
    %converting the j and f responses into a logical. J = it got faster.
    lineSFRespCell = strfind(validlineSResponses, 'f');
    lineSJResponses = cellfun('isempty', lineSFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    lineSFasterResponses = validlineSCondNumber(lineSJResponses);
    allConds = unique(validlineSCondNumber);
    
    lineSNumPos = histc(lineSFasterResponses, allConds)'; %the number of it got faster responses for each level in the lineS condition
    lineSOutOfNum = histc(validlineSCondNumber,allConds)'; %the number of trials in each level in the lineS condition
    
    
    %load line continuous data
    
    lineCFileDir = strcat('/Users/Abigail/Documents/Experiment_Data/Experiment_9/',...
        currParticipantCode, '/movingLine_continuous_*');
    lineCfilenames = dir(lineCFileDir);
    lineCfilenames = {lineCfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for ilineCFiles = 1:length(lineCfilenames)
        lineCfilenamestr = char(lineCfilenames(ilineCFiles));
        lineCDataFile(ilineCFiles) = load(lineCfilenamestr); %loads all of the files to be analysed together
    end
    
    lineCExperimentData = [lineCDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = lineCDataFile.sessionInfo; %all of the session info data in one combined struct
    lineCResponseTable = struct2table(lineCExperimentData);
    
    %excluding invalid trials
    validlineCData = ~(lineCResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validlineCResponses = lineCResponseTable.response(validlineCData); %
    validlineCCondNumber = lineCResponseTable.condNumber(validlineCData);
    
    %converting the j and f responses into a logical. J = it got faster.
    lineCFRespCell = strfind(validlineCResponses, 'f');
    lineCJResponses = cellfun('isempty', lineCFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    lineCFasterResponses = validlineCCondNumber(lineCJResponses);
    allConds = unique(validlineCCondNumber);
    
    lineCNumPos = histc(lineCFasterResponses, allConds)';
    lineCOutOfNum = histc(validlineCCondNumber,allConds)';
    
    %load dot simultaneous data
    
    dotSFileDir = strcat('/Users/Abigail/Documents/Experiment_Data/Experiment_9/',...
        currParticipantCode, '/movingDots_simultaneous_*');
    dotSfilenames = dir(dotSFileDir);
    dotSfilenames = {dotSfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for idotSFiles = 1:length(dotSfilenames)
        dotSfilenamestr = char(dotSfilenames(idotSFiles));
        dotSDataFile(idotSFiles) = load(dotSfilenamestr); %loads all of the files to be analysed together
    end
    
    dotSExperimentData = [dotSDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = dotSDataFile.sessionInfo; %all of the session info data in one combined struct
    dotSResponseTable = struct2table(dotSExperimentData);
    
    %excluding invalid trials
    validdotSData = ~(dotSResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validdotSResponses = dotSResponseTable.response(validdotSData); %
    validdotSCondNumber = dotSResponseTable.condNumber(validdotSData);
    
    %converting the j and f responses into a logical. J = it got faster.
    dotSFRespCell = strfind(validdotSResponses, 'f');
    dotSJResponses = cellfun('isempty', dotSFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    dotSFasterResponses = validdotSCondNumber(dotSJResponses);
    allConds = unique(validdotSCondNumber);
    
    dotSNumPos = histc(dotSFasterResponses, allConds)';
    dotSOutOfNum = histc(validdotSCondNumber,allConds)';
    
    %load dot continuous data
    
    dotCFileDir = strcat('/Users/Abigail/Documents/Experiment_Data/Experiment_9/',...
        currParticipantCode, '/movingDots_continuous_', currParticipantCode,'_*');
    dotCfilenames = dir(dotCFileDir);
    dotCfilenames = {dotCfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for idotCFiles = 1:length(dotCfilenames)
        dotCfilenamestr = char(dotCfilenames(idotCFiles));
        dotCDataFile(idotCFiles) = load(dotCfilenamestr); %loads all of the files to be analysed together
    end
    
    dotCExperimentData = [dotCDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = dotCDataFile.sessionInfo; %all of the session info data in one combined struct
    dotCResponseTable = struct2table(dotCExperimentData);
    
    %excluding invalid trials
    validdotCData = ~(dotCResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validdotCResponses = dotCResponseTable.response(validdotCData); %
    validdotCCondNumber = dotCResponseTable.condNumber(validdotCData);
    
    %converting the j and f responses into a logical. J = it got faster.
    dotCFRespCell = strfind(validdotCResponses, 'f');
    dotCJResponses = cellfun('isempty', dotCFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    dotCFasterResponses = validdotCCondNumber(dotCJResponses);
    allConds = unique(validdotCCondNumber);
    
    dotCNumPos = histc(dotCFasterResponses, allConds)';
    dotCOutOfNum = histc(validdotCCondNumber,allConds)';
    
     %load dot continuous alternative data
    
    dotCAFileDir = strcat('/Users/Abigail/Documents/Experiment_Data/Experiment_9/',...
        currParticipantCode, '/movingDots_continuous_alternative_*');
    dotCAfilenames = dir(dotCAFileDir);
    dotCAfilenames = {dotCAfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for idotCAFiles = 1:length(dotCAfilenames)
        dotCAfilenamestr = char(dotCAfilenames(idotCAFiles));
        dotCADataFile(idotCAFiles) = load(dotCAfilenamestr); %loads all of the files to be analysed together
    end
    
    dotCAExperimentData = [dotCADataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = dotCADataFile.sessionInfo; %all of the session info data in one combined struct
    dotCAResponseTable = struct2table(dotCAExperimentData);
    
    %excluding invalid trials
    validdotCAData = ~(dotCAResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validdotCAResponses = dotCAResponseTable.response(validdotCAData); %
    validdotCACondNumber = dotCAResponseTable.condNumber(validdotCAData);
    
    %converting the j and f responses into a logical. J = it got faster.
    dotCAFRespCell = strfind(validdotCAResponses, 'f');
    dotCAJResponses = cellfun('isempty', dotCAFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    dotCAFasterResponses = validdotCACondNumber(dotCAJResponses);
    allConds = unique(validdotCACondNumber);
    
    dotCANumPos = histc(dotCAFasterResponses, allConds)';
    dotCAOutOfNum = histc(validdotCACondNumber,allConds)';
    
    
    %creating the matrices used in the PAL_PFML_FitMultiple
    StimLevels = repmat([6 9 10.8 12 13.2 15 18], 5,1);
    NumPos = vertcat(lineSNumPos, lineCNumPos, dotSNumPos, dotCNumPos, dotCANumPos); %matrix of "it got faster" responses in each of the 5 conditions
    OutOfNum = vertcat(lineSOutOfNum, lineCOutOfNum, dotSOutOfNum, dotCOutOfNum, dotCAOutOfNum); %matrix of number of trials in each condition for each of the 5 conditions
    paramsValues = [13 0.1 0.03 0.03];
    
    
    %fitting the psychometric function
    paramsFree = [1 1 0 1];
    PF = @PAL_CumulativeNormal;
    
    %lapsefits parameters
    thresholdsLapseFits = 'unconstrained';
    slopeLapseFits = 'unconstrained';
    lapseFits = 'constrained';
    lapseFit = 'iAPLE';
    
    results = struct();
    [results.paramsValues results.LL results.exitflag results.output] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF, 'lapserates', lapseFits,...
        'thresholds', thresholdsLapseFits, 'slopes', slopeLapseFits, 'lapseLimits',[0 .3], 'lapseFit', lapseFit, 'gammaeqlambda', 1);
    
    results.PF        = PF;
    results.StimLevels = StimLevels;
    results.NumPos    = NumPos;
    results.OutOfNum   = OutOfNum;
    results.fiftyPercentPoints = results.paramsValues(:,1);
    
    for iVal = 1:length(results.paramsValues)
        results.threshold75(iVal) = PAL_CumulativeNormal(results.paramsValues(iVal,:), 0.75, 'Inverse');
        results.Slope(iVal) = PAL_CumulativeNormal(results.paramsValues(iVal,:),...
            results.threshold75(iVal), 'Derivative');
    end
    
    %Create simple plot for each condition separately
    
    for iCondRow = 1:5
        proportionFaster=results.NumPos(iCondRow, :)./results.OutOfNum(iCondRow, :);
        StimLevelsFineGrain=[min(results.StimLevels(1,:)):max(results.StimLevels(1,:))./1000:max(results.StimLevels(1,:))];
        ProportionCorrectModel = PF(results.paramsValues(iCondRow,:),StimLevelsFineGrain);
        currentCond = num2str(iCondRow);
        graphtitle = strcat(currParticipantCode, '_', currentCond);
        
        figure;
        axes
        hold on
        plot(StimLevelsFineGrain,ProportionCorrectModel,'-','color',[.7 .7 .7],'linewidth',4);
        plot(results.StimLevels(1,:),proportionFaster,'k.','markersize',40);
        set(gca, 'fontsize',16);
        set(gca, 'Xtick', results.StimLevels(1,:));
        axis([min(results.StimLevels(1,:)) max(results.StimLevels(1,:)) 0 1]);
        xlabel('Speed (deg/s)');
        ylabel('proportion faster responses');
        title(graphtitle, 'interpreter', 'none');
        
        figFileName = strcat(graphtitle, '_dotslines_lapse_psychometric_analysis.pdf');
        saveas(gcf, figFileName);
        
    end
    
    dataToSave = vertcat(results.fiftyPercentPoints', results.threshold75, results.Slope, results.paramsValues');
    resultsTable = table(dataToSave);
    resultsFileName = strcat(currParticipantCode, '_dotslines_lapse_psychometric_analysis.csv');
    writetable(resultsTable, resultsFileName);
    
end
