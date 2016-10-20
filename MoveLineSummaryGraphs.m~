
participantCodes = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J'}; %'K'

analysisType = {'arcmin' ...
        'arcmin_less',...
    'speed_change_changepoint', ...
    'speed_change_changepoint_less',...
    'speed_change_start_end_less', ...
    'speed_change_start_end'};

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
        grid on
        set(gca, 'XTick', 1:1:8);
        set(gca, 'XTickLabel', shortenedCondList);
        set(gca, 'fontsize',13);
        xlabel('Condition');
        ylabel('75% threshold');
        thresholdTitle = strcat('Threshold_', currAnalysisType, '_', currParticipantCode);
        title(thresholdTitle, 'interpreter', 'none');
        
        thresholdfigFileName = strcat('threshold_summary_graph_', currAnalysisType, '_', currParticipantCode, '.pdf');
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 5 8.5 5.5];
        print(thresholdfigFileName,'-dpdf','-r0')
        
        hold off
        
        figure
        hold on
        bar(slopes, 'b');
        errorbar(1:1:8, slopes, slopeLowerCIsize, slopeUpperCIsize, '.k');
        grid on %this puts a grid in the background of your graph to make 
        %it a bit clearer to look at 
        set(gca, 'XTick', 1:1:8);
        set(gca, 'XTickLabel', shortenedCondList);
        set(gca, 'fontsize',13);
        xlabel('Condition');
        ylabel('Slope at 75% correct');
        slopeTitle = strcat('Slope_', currAnalysisType, '_', currParticipantCode);
        title(slopeTitle,'interpreter', 'none');
        
        slopesfigFileName = strcat('slopes_summary_graph_', currAnalysisType, '_', currParticipantCode, '.pdf');
        
        %this allows you to specify the size that the figure will be
        %printed as in a pdf, rather than just the default. 
        fig = gcf; %you say fig is the current figure handle
        fig.PaperUnits = 'inches'; %say the paper units are inches
        fig.PaperPosition = [0 5 8.5 5.5]; %you then specify the x and y 
        %starting coordinates of the graph on the paper followed by the
        %size in inches of the graph
        print(slopesfigFileName,'-dpdf','-r0') %this prints the current 
        %figure with the specified size to the name in slopesfigFileName as
        %a pdf.
        
        hold off
        
    end
    
end

