
participantCodes = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J'}; %'K'

analysisType = {'arcmin', ...
    'speed_change_start_end', ...
    'arcmin_less',...
    'speed_change_changepoint_less',...
    'speed_change_start_end_less', ...
    'speed_change_changepoint'};

% conditionList = {'MoveLine_accelerating_depth_midspeed'; ...
%     'MoveLine_accelerating_depth_slow'; 'MoveLine_accelerating_lateral_midspeed'; ...
%     'MoveLine_accelerating_lateral_slow'; 'MoveLine_CRS_depth_midspeed'; ...
%     'MoveLine_CRS_depth_slow'; 'MoveLine_CRS_lateral_midspeed'; 'MoveLine_CRS_lateral_slow'};

shortenedCondList = {'ADM' 'ADS' 'ALM' 'ALS' 'CRSDM' 'CRSDS' 'CRSLM' 'CRSLS'};

for iParticipant = 1:length(participantCodes)
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    for iAnalysis = 1:length(analysisType)
        currAnalysisType = cell2mat(analysisType(iAnalysis));
        filename = strcat('/Users/Abigail/Documents/Experiment Data/Experiment 1/Participant_', ...
            currParticipantCode, '/Analysis/', currAnalysisType,'/psychometric_data_',...
            currAnalysisType,'_', currParticipantCode, '.csv');

        allPsychData = csvread(filename, 1, 1);
        usefulPsychData = allPsychData(:, 1:8); %all rows giving all
        %conditions, then only rows 1-8, giving only the threshold, slope,
        %CIs for the threshold, CIs for the slope, SE for the threshold and
        %SE for the slope.
        
        %threshold information
        thresholds = usefulPsychData(:,1);
        thresholdLowerCI = usefulPsychData(:,3);
        thresholdUpperCI = usefulPsychData(:,4);
        thresholdLowerCIsize = thresholds - thresholdLowerCI;
        thresholdUpperCIsize = thresholdUpperCI - thresholds;
        thresholdSE = usefulPsychData(:,7);
        
        %slope information
        slopes = usefulPsychData(:,2);
        slopeLowerCI = usefulPsychData(:,5);
        slopeUpperCI = usefulPsychData(:,6);
        slopeLowerCIsize = slopes - slopeLowerCI;
        slopeUpperCIsize = slopeUpperCI - slopes;
        slopeSE = usefulPsychData(:,8);
        
        figure
        hold on
        bar(thresholds, 'r');
        errorbar(1:1:8, thresholds, thresholdLowerCIsize, thresholdUpperCIsize, '.k');
        set(gca, 'XTick', 1:1:8);
        set(gca, 'XTickLabel', shortenedCondList);
        thresholdfigFileName = strcat('threshold_summary_graph_', currAnalysisType, '_', currParticipantCode, '.pdf');
        saveas(gcf, thresholdfigFileName);
        hold off
        
        figure
        hold on
        bar(slopes, 'b');
        errorbar(1:1:8, slopes, slopeLowerCIsize, slopeUpperCIsize, '.k');
        set(gca, 'XTick', 1:1:8);
        set(gca, 'XTickLabel', shortenedCondList);
        slopesfigFileName = strcat('slopes_summary_graph_', currAnalysisType, '_', currParticipantCode, '.pdf');
        saveas(gcf, slopesfigFileName);
        hold off
        
    end
    
end

