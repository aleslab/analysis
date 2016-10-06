clearvars;
cd /Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data %lab mac
participantCodes = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H'}; % 'J' 'K'
ParOrNonPar = 2; %non-parametric bootstrap for all
B = 1000; %number of simulations for all bootstraps and goodness of fits

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    
    conditionList = {'MoveLine_accelerating_depth_midspeed'; ...
        'MoveLine_accelerating_depth_slow'; 'MoveLine_accelerating_lateral_midspeed'; ...
        'MoveLine_accelerating_lateral_slow'; 'MoveLine_CRS_depth_midspeed'; ...
        'MoveLine_CRS_depth_slow'; 'MoveLine_CRS_lateral_midspeed'; 'MoveLine_CRS_lateral_slow'};
    
    analysisType = {'arcmin_less' 'arcmin', 'speed_change_start_end',  'speed_change_changepoint'};
    for iAnalysis = 1:length(analysisType)
        currAnalysisType = cell2mat(analysisType(iAnalysis));
        for iCond = 1:length(conditionList)
            currCondition = cell2mat(conditionList(iCond));
            condAndParticipant = strcat(currCondition, '_', currParticipantCode);
            
            fileDir = strcat('/Users/Abigail/Documents/Experiment Data/Experiment 1/Participant_', currParticipantCode, '/', condAndParticipant, '_*');
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
            %condInfo = allSessionInfo.conditionInfo;
            
            %% Getting the speed difference in arcmin/s
            if strcmp(currAnalysisType, 'arcmin')
                
                %midspeed accelerating conditions
                if strcmp(currCondition, 'MoveLine_accelerating_depth_midspeed') || strcmp(currCondition,'MoveLine_accelerating_lateral_midspeed');
                    
                    s1minspeeds = [30.1 26.4 22.6 18.8 15.1 11.3 7.5];
                    s1maxspeeds = [43.8 36.4 29.7 23.6 18.0 12.9 8.2];
                    s1averagespeeds = (s1minspeeds+s1maxspeeds)./2;
                    
                    s2minspeeds = [43.9 46.9 49.6 52.0 54.1 55.9 57.6];
                    s2maxspeeds = [69.5 78.1 86.8 95.5 104.1 112.8 121.4];
                    s2averagespeeds = (s2minspeeds+s2maxspeeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Section average change in speed between sections (arcmin/s)';
                    
                    %slow accelerating conditions
                elseif strcmp(currCondition, 'MoveLine_accelerating_depth_slow') || strcmp(currCondition,'MoveLine_accelerating_lateral_slow');
                    
                    s1minspeeds = [18.0 15.8 13.5 11.3 9.0 6.8 4.5];
                    s1maxspeeds = [21.9 18.7 15.6 12.7 9.9 7.3 4.7];
                    s1averagespeeds = (s1minspeeds+s1maxspeeds)./2;
                    
                    s2minspeeds = [21.9 24.0 26.0 27.9 29.7 31.4 33.1];
                    s2maxspeeds = [27.2 30.6 34.0 37.4 40.8 44.2 47.6];
                    s2averagespeeds = (s2minspeeds+s2maxspeeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Section average change in speed between sections (arcmin/s)';
                    
                    %CRS depth conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_midspeed');
                    
                    l1s1speeds = [31.75 21.2 17.6 14.1 10.9 8 5];
                    l2s1speeds = [63.45 42.4 35.2 28.3 21.9 16 10.2];
                    s1averagespeeds = (l1s1speeds+l2s1speeds)./2;
                    
                    l1s2speeds = [31.75 42.3 45.9 49.4 52.6 55.5 58.3];
                    l2s2speeds = [63.45 84.5 91.7 98.6 105 110.9 116.5];
                    s2averagespeeds = (l1s2speeds+l2s2speeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Line average change in speed between sections (arcmin/s)';
                    
                    %slow and midspeed CRS lateral conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_slow');
                    
                    l1s1speeds = [14.85 11.43 9.74 8 6.25 4.67 3.07];
                    l2s1speeds = [29.75 22.97 19.46 16 12.55 9.33 6.13];
                    s1averagespeeds = (l1s1speeds+l2s1speeds)./2;
                    
                    l1s2speeds = [14.85 18.27 19.96 21.7 23.45 25.03 26.63];
                    l2s2speeds = [29.75 36.53 40.04 43.5 46.95 50.17 53.37];
                    s2averagespeeds = (l1s2speeds+l2s2speeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Line average change in speed between sections (arcmin/s)';
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_midspeed');
                    
                    s1speeds = [47.6 31.8 26.4 21.3 16.5 11.9 7.7];
                    s2speeds = [47.6 63.4 68.8 73.9 78.7 83.2 87.5];
                    speedDiff = s2speeds - s1speeds;
                    
                    xLabelTitle  = 'Change in speed between sections (arcmin/s)';
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_slow');
                    
                    s1speeds = [22.3 17.3 14.6 12.0 9.5 7.0 4.6];
                    s2speeds = [22.3 27.4 30.1 32.7 35.2 37.7 40.1];
                    speedDiff = s2speeds - s1speeds;
                    
                    xLabelTitle  = 'Change in speed between sections (arcmin/s)';
                    
                end
                
                % for analysing the data in terms of the change in arcmin/s, but only for
                % the first 6 conditions. Hopefully this will remove the effect of diplopia
                % in some conditions.
            elseif strcmp(currAnalysisType, 'arcmin_less');
                
                condCorrectNumbers = condCorrectNumbers(1:6);
                allTrialNumbers = allTrialNumbers(1:6);
                
                %midspeed accelerating conditions
                if strcmp(currCondition, 'MoveLine_accelerating_depth_midspeed') || strcmp(currCondition,'MoveLine_accelerating_lateral_midspeed');
                    
                    s1minspeeds = [30.1 26.4 22.6 18.8 15.1 11.3];
                    s1maxspeeds = [43.8 36.4 29.7 23.6 18.0 12.9];
                    s1averagespeeds = (s1minspeeds+s1maxspeeds)./2;
                    
                    s2minspeeds = [43.9 46.9 49.6 52.0 54.1 55.9];
                    s2maxspeeds = [69.5 78.1 86.8 95.5 104.1 112.8];
                    s2averagespeeds = (s2minspeeds+s2maxspeeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Section average change in speed between sections (arcmin/s)';
                    
                    %slow accelerating conditions
                elseif strcmp(currCondition, 'MoveLine_accelerating_depth_slow') || strcmp(currCondition,'MoveLine_accelerating_lateral_slow');
                    
                    s1minspeeds = [18.0 15.8 13.5 11.3 9.0 6.8];
                    s1maxspeeds = [21.9 18.7 15.6 12.7 9.9 7.3];
                    s1averagespeeds = (s1minspeeds+s1maxspeeds)./2;
                    
                    s2minspeeds = [21.9 24.0 26.0 27.9 29.7 31.4];
                    s2maxspeeds = [27.2 30.6 34.0 37.4 40.8 44.2];
                    s2averagespeeds = (s2minspeeds+s2maxspeeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Section average change in speed between sections (arcmin/s)';
                    
                    %CRS depth conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_midspeed');
                    
                    l1s1speeds = [31.75 21.2 17.6 14.1 10.9 8];
                    l2s1speeds = [63.45 42.4 35.2 28.3 21.9 16];
                    s1averagespeeds = (l1s1speeds+l2s1speeds)./2;
                    
                    l1s2speeds = [31.75 42.3 45.9 49.4 52.6 55.5];
                    l2s2speeds = [63.45 84.5 91.7 98.6 105 110.9];
                    s2averagespeeds = (l1s2speeds+l2s2speeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Line average change in speed between sections (arcmin/s)';
                    
                    %slow and midspeed CRS lateral conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_slow');
                    
                    l1s1speeds = [14.85 11.43 9.74 8 6.25 4.67];
                    l2s1speeds = [29.75 22.97 19.46 16 12.55 9.33];
                    s1averagespeeds = (l1s1speeds+l2s1speeds)./2;
                    
                    l1s2speeds = [14.85 18.27 19.96 21.7 23.45 25.03];
                    l2s2speeds = [29.75 36.53 40.04 43.5 46.95 50.17];
                    s2averagespeeds = (l1s2speeds+l2s2speeds)./2;
                    
                    speedDiff = s2averagespeeds - s1averagespeeds;
                    
                    xLabelTitle  = 'Line average change in speed between sections (arcmin/s)';
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_midspeed');
                    
                    s1speeds = [47.6 31.8 26.4 21.3 16.5 11.9];
                    s2speeds = [47.6 63.4 68.8 73.9 78.7 83.2];
                    speedDiff = s2speeds - s1speeds;
                    
                    xLabelTitle  = 'Change in speed between sections (arcmin/s)';
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_slow');
                    
                    s1speeds = [22.3 17.3 14.6 12.0 9.5 7.0];
                    s2speeds = [22.3 27.4 30.1 32.7 35.2 37.7];
                    speedDiff = s2speeds - s1speeds;
                    
                    xLabelTitle  = 'Change in speed between sections (arcmin/s)';
                    
                end
                
                % to do the analysis in terms of the percentage speed change, but comparing
                %the difference in speed at the beginning and end of the interval
            elseif strcmp(currAnalysisType, 'speed_change_start_end');
                
                xLabelTitle  = 'Percentage speed change between the interval start and end';
                
                %midspeed accelerating conditions
                if strcmp(currCondition, 'MoveLine_accelerating_depth_midspeed') || strcmp(currCondition,'MoveLine_accelerating_lateral_midspeed');
                    
                    speedDiff = [0.57 0.66 0.74 0.80 0.85 0.90 0.94]; %2dp
                    
                    %slow accelerating conditions
                elseif strcmp(currCondition, 'MoveLine_accelerating_depth_slow') || strcmp(currCondition,'MoveLine_accelerating_lateral_slow');
                    
                    speedDiff = [0.34 0.48 0.60 0.70 0.78 0.85 0.91]; %2dp
                    
                    %CRS depth conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_midspeed');
                    
                    speedDiff = [0 0.50 0.62 0.71 0.79 0.86 0.91]; %2dp
                    
                    %slow and midspeed CRS lateral conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_slow');
                    
                    speedDiff = [0 0.37 0.51 0.63 0.73 0.81 0.88]; %2dp
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_midspeed');
                    
                    speedDiff = [0 0.50 0.62 0.71 0.79 0.86 0.91]; %2dp
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_slow');
                    
                    speedDiff = [0 0.37 0.51 0.63 0.73 0.81 0.89]; %2dp
                    
                end
                
            elseif strcmp(currAnalysisType, 'speed_change_changepoint');
                
                xLabelTitle  = 'Percentage speed change at the point of the speed change';
                
                %midspeed accelerating conditions
                if strcmp(currCondition, 'MoveLine_accelerating_depth_midspeed') || strcmp(currCondition,'MoveLine_accelerating_lateral_midspeed');
                    
                    speedDiff = [0 0.22 0.40 0.55 0.67 0.77 0.86]; %2dp
                    
                    %slow accelerating conditions
                elseif strcmp(currCondition, 'MoveLine_accelerating_depth_slow') || strcmp(currCondition,'MoveLine_accelerating_lateral_slow');
                    
                    speedDiff = [0 0.22 0.40 0.54 0.67 0.77 0.86]; %2dp
                    
                    
                    %CRS depth conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_midspeed');
                    
                    speedDiff = [0 0.50 0.62 0.71 0.79 0.86 0.91]; %2dp
                    
                    %slow and midspeed CRS lateral conditions
                elseif strcmp(currCondition, 'MoveLine_CRS_depth_slow');
                    
                    speedDiff = [0 0.37 0.51 0.63 0.73 0.81 0.88]; %2dp
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_midspeed');
                    
                    speedDiff = [0 0.50 0.62 0.71 0.79 0.86 0.91]; %2dp
                    
                elseif strcmp(currCondition, 'MoveLine_CRS_lateral_slow');
                    
                    speedDiff = [0 0.37 0.51 0.63 0.73 0.81 0.89]; %2dp
                    
                end
                
            end
            
            %% Psychometric function fitting adapted from PAL_PFML_Demo
            
            tic
            
            PF = @PAL_CumulativeNormal;
            
            %Threshold and Slope are free parameters, guess and lapse rate are fixed
            paramsFree = [1 1 0 0];  %1: free parameter, 0: fixed parameter
            
            %Parameter grid defining parameter space through which to perform a
            %brute-force search for values to be used as initial guesses in iterative
            %parameter search.
            searchGrid.alpha = linspace(min(speedDiff),max(speedDiff),101);
            searchGrid.beta = linspace(0,(30/max(speedDiff)),101);
            searchGrid.gamma = 0.5;  %scalar here (since fixed) but may be vector
            searchGrid.lambda = 0;  %ditto
            
            %Perform fit
            disp('Fitting function.....');
            [paramsValues, LL, exitflag] = PAL_PFML_Fit(speedDiff,condCorrectNumbers, ...
                allTrialNumbers,searchGrid,paramsFree,PF);
            
            disp('done:')
            message = sprintf('Threshold estimate: %6.4f',paramsValues(1));
            disp(message);
            message = sprintf('Slope estimate: %6.4f\r',paramsValues(2));
            disp(message);
            
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
            xlabel(xLabelTitle);
            ylabel('proportion correct');
            title(condAndParticipant, 'interpreter', 'none');
            
            figFileName = strcat('psychometric_', currAnalysisType, '_', condAndParticipant, '.pdf');
            saveas(gcf, figFileName);
            
            if strcmp(currAnalysisType, 'arcmin');
                
                RawDataExcelFileName = strcat('raw_data_', condAndParticipant, '.csv');
                writetable(ResponseTable, RawDataExcelFileName);
            end
            
            
            %%
            stimAt75PercentCorrect = PAL_CumulativeNormal(paramsValues, 0.75, 'Inverse');
            slopeAt75PercentThreshold = PAL_CumulativeNormal(paramsValues, stimAt75PercentCorrect, 'Derivative');
            % this slope value might not be particularly close to the beta
            %value that comes out of the paramsValues things as with the
            %cumulative normal function the beta value is the inverse of
            %the standard deviation, which is related/proportional to the
            %slope but not actually the slope.  
            
            for iBootThreshold = 1:length(B)
                boot75Threshold(iBootThreshold) = PAL_CumulativeNormal(paramsSim, 0.75, 'Inverse');
            end
            
            for iBootSlope = 1:length(B)
                bootSlopeAt75Threshold(iBootSlope) = PAL_CumulativeNormal(paramsSim, stimAt75PercentCorrect, 'Derivative');
            end
            
            thresholdSE = std(boot75Threshold);
            slopeSE = std(bootSlopeAt75Threshold);
            
            sortedThresholdSim = sort(boot75Threshold);
            sortedSlopeSim = sort(bootSlopeAt75Threshold);
            thresholdCI = [sortedThresholdSim(25) sortedThresholdSim(975)];
            slopeCI = [sortedSlopeSim(25) sortedThresholdSim(975)];
            
            psychInfo(iCond).condition = currCondition;
            %correct values that i've calculated
            psychInfo(iCond).stimAt75PercentCorrect = stimAt75PercentCorrect;
            psychInfo(iCond).slopeAt75PercentThreshold = slopeAt75PercentThreshold;
            psychInfo(iCond).alphaCI = thresholdCI;
            psychInfo(iCond).betaCI = slopeCI;
            psychInfo(iCond).thresholdSE = thresholdSE;
            psychInfo(iCond).slopeSE = slopeSE;
            %the original parameters, standard errors from bootstrapping
            %and values from goodness of fit (dev and pdev).
            psychInfo(iCond).condParamsValues = paramsValues;
            psychInfo(iCond).condParamsSE = SD;
            psychInfo(iCond).condParamsDev = Dev;
            psychInfo(iCond).condParamsPDev = pDev;
            
            toc
        end
        psychTable = struct2table(psychInfo);
        psychExcelFileName = strcat('psychometric_data_', currAnalysisType, '_', currParticipantCode, '.csv');
        writetable(psychTable, psychExcelFileName);
    end
end
