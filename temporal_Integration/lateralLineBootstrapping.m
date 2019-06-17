clearvars;
cd /Users/Abigail/Documents/Experiment_Data/Experiment_6 %lab mac

participantCodes = {'AW' 'AX' 'AZ' 'BA' 'BB' 'BD' 'BF' 'BE' 'AS'}; % = experiment 6
BootNo = 1000; %number of simulations for all bootstraps and goodness of fits

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    
    %experiment 3 conditions
    conditionList = {'lateralLine_shortDuration'; 'lateralLine_midDuration'; 'lateralLine_longDuration'};
    
    
    for iCond = 1:length(conditionList)
        currCondition = cell2mat(conditionList(iCond));
        condAndParticipant = strcat(currCondition, '_', currParticipantCode);
        
        %experiment 3
        fileDir = strcat('/Users/Abigail/Documents/Experiment_Data/Experiment_6/', currParticipantCode, '/', condAndParticipant, '_*');
        
        filenames = dir(fileDir);
        filenames = {filenames.name}; %makes a cell of filenames from the same
        %participant and condition to be loaded together
        
        for iFiles = 1:length(filenames)
            filenamestr = char(filenames(iFiles));
            dataFile(iFiles) = load(filenamestr); %loads all of the files to be analysed together
        end
        
        allExperimentData = [dataFile.experimentData]; %all of the experiment data in one combined struct
        allSessionInfo = dataFile.sessionInfo; %all of the session info data in one combined struct
        ResponseTable = struct2table(allExperimentData); %The data struct is converted to a table
        
            %excluding invalid trials
    validData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validResponses = ResponseTable.response(validData); %
    validCondNumber = ResponseTable.condNumber(validData);
    
    %converting the j and f responses into a logical. J = it got faster.
    FRespCell = strfind(validResponses, 'f');
    JResponses = cellfun('isempty', FRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    FasterResponses = validCondNumber(JResponses);
    allConds = unique(validCondNumber);
    
    NumPos = histc(FasterResponses, allConds)'; %the number of it got faster responses for each level in the zero condition
    OutOfNum = histc(validCondNumber,allConds)'; %the number of trials in each level in the zero condition
        
        xLabelTitle  = 'Speed difference (deg/s)';
        
        speedDiff = [6.7032 7.6593 8.7517 10.0000 11.4263 13.0561 14.9182];
        
        PF = @PAL_CumulativeNormal;
        
        %Threshold and Slope are free parameters, guess and lapse rate are fixed
        paramsFree = [1 1 0 0];  %1: free parameter, 0: fixed parameter
        
        %Parameter grid defining parameter space through which to perform a
        %brute-force search for values to be used as initial guesses in iterative
        %parameter search.
        searchGrid.alpha = linspace(min(speedDiff),max(speedDiff),101);
        searchGrid.beta = linspace(0,(30/max(speedDiff)),101);
        searchGrid.gamma = 0;  %scalar here (since fixed) but may be vector
        searchGrid.lambda = 0;  %ditto
        
        %Perform fit
        disp('Fitting function.....');
        [paramsValues, LL, exitflag] = PAL_PFML_Fit(speedDiff,NumPos, ...
            OutOfNum,searchGrid,paramsFree,PF);
        
        disp('done:')
        message = sprintf('Threshold estimate: %6.4f',paramsValues(1));
        disp(message);
        message = sprintf('Slope estimate: %6.4f\r',paramsValues(2));
        disp(message);
        
        disp('Determining standard errors.....');
        
        
        [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapNonParametric(...
            speedDiff, NumPos, OutOfNum, [], paramsFree, BootNo, PF,...
            'searchGrid',searchGrid);
        
        bootstrapInfo(iCond).SD = SD;
        bootstrapInfo(iCond).paramsSim = paramsSim;
        bootstrapInfo(iCond).LLSim = LLSim;
        bootstrapInfo(iCond).converged = converged;
        
        
        disp('done:');
        %Create simple plot
        ProportionCorrectObserved=NumPos./OutOfNum;
        StimLevelsFineGrain=[min(speedDiff):max(speedDiff)./1000:max(speedDiff)];
        ProportionCorrectModel = PF(paramsValues,StimLevelsFineGrain);
        
        figure;
        axes
        hold on
        plot(StimLevelsFineGrain,ProportionCorrectModel,'-','color',[0 .7 0],'linewidth',4);
        plot(speedDiff,ProportionCorrectObserved,'-k.','markersize',40);
        set(gca, 'fontsize',16);
        set(gca, 'Xtick', speedDiff);
        axis([min(speedDiff) max(speedDiff) 0 1]);
        xlabel(xLabelTitle);
        ylabel('proportion correct');
        title(condAndParticipant, 'interpreter', 'none');
        
        figFileName = strcat('psychometricFit_', condAndParticipant, '.pdf');
        saveas(gcf, figFileName);
        
        
        per50 = PAL_CumulativeNormal(paramsValues, 0.5, 'Inverse');
        per75 = PAL_CumulativeNormal(paramsValues, 0.75, 'Inverse');
        weberFraction = (per75 - per50)/per50;
        
        for iBoot = 1:BootNo
            boot50point(iBoot) = PAL_CumulativeNormal(paramsSim(iBoot,:), 0.5, 'Inverse');
            boot75point(iBoot) = PAL_CumulativeNormal(paramsSim(iBoot,:), 0.75, 'Inverse');
            bootWeberFraction(iBoot) = (boot75point(iBoot) - boot50point(iBoot))/boot50point(iBoot);
        end
        
        per50SE = std(boot50point);
        per75SE = std(boot75point);
        weberFractionSE = std(bootWeberFraction);
        
        psychInfo(iCond).condition = currCondition;
        %correct values that i've calculated
        psychInfo(iCond).per50 = per50;
        psychInfo(iCond).per75 = per75;
        psychInfo(iCond).weberFraction = weberFraction;
        psychInfo(iCond).per50SE = per50SE;
        psychInfo(iCond).per75SE = per75SE;
        psychInfo(iCond).weberFractionSE = weberFractionSE;
        
        %the original parameters, standard errors from bootstrapping
        %and values from goodness of fit (dev and pdev).
        psychInfo(iCond).condParamsValues = paramsValues;
        psychInfo(iCond).condParamsSE = SD;

    end
    
    psychTable = struct2table(psychInfo);
    psychExcelFileName = strcat('psychometric_data_', currParticipantCode, '.csv');
    writetable(psychTable, psychExcelFileName);
    
end