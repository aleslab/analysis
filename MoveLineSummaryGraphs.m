
participantCodes = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J'}; %'K'

analysisType = {'arcmin' ...
    'arcmin_less',...
    'speed_change_changepoint', ...
    'speed_change_changepoint_less',...
    'speed_change_start_end', ...
    'speed_change_start_end_less'};

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
        
        psychData(iAnalysis).data = usefulPsychData;
        
    end
    
    participantData(iParticipant).psychData = psychData;
end

close all;
%% summary of every participant together in each analysis type
%adding all arcmin values from each participant
allArcminData = [participantData(1).psychData(1).data] + [participantData(2).psychData(1).data] ...
    + [participantData(3).psychData(1).data] + [participantData(4).psychData(1).data] + ...
    [participantData(5).psychData(1).data] + [participantData(6).psychData(1).data] + ...
    [participantData(7).psychData(1).data] + [participantData(8).psychData(1).data] + ...
    [participantData(9).psychData(1).data]; % + [participantData(10).psychData(1).data];

averageArcmin = allArcminData./(length(participantCodes));
averageArcminThres = averageArcmin(:, 1);
averageArcminSlopes = averageArcmin(:,2);

figure
bar(averageArcminThres, 'r');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean threshold across participants (arcmin)');

figFileName = 'Average_Arcmin_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

figure
bar(averageArcminSlopes, 'b');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean slope across participants (arcmin)');

figFileName = 'Average_Arcmin_Slopes';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

%adding all arcmin_less values from each participant
allArcminLessData = [participantData(1).psychData(2).data] + [participantData(2).psychData(2).data] ...
    + [participantData(3).psychData(2).data] + [participantData(4).psychData(2).data] + ...
    [participantData(5).psychData(2).data] + [participantData(6).psychData(2).data] + ...
    [participantData(7).psychData(2).data] + [participantData(8).psychData(2).data] + ...
    [participantData(9).psychData(2).data]; % + [participantData(10).psychData(2).data];

averageArcminLess = allArcminLessData./(length(participantCodes));
averageArcminLessThres = averageArcminLess(:, 1);
averageArcminLessSlopes = averageArcminLess(:,2);

figure
bar(averageArcminLessThres, 'r');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean threshold across participants with 6/7 levels (arcmin)');

figFileName = 'Average_Arcmin_Less_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

figure
bar(averageArcminLessSlopes, 'b');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean slope across participants with 6/7 levels (arcmin)');

figFileName = 'Average_Arcmin_Less_Slopes';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

%adding all speed_change_changepoint values from each participant
allChangepointData = [participantData(1).psychData(3).data] + [participantData(2).psychData(3).data] ...
    + [participantData(3).psychData(3).data] + [participantData(4).psychData(3).data] + ...
    [participantData(5).psychData(3).data] + [participantData(6).psychData(3).data] + ...
    [participantData(7).psychData(3).data] + [participantData(8).psychData(3).data] + ...
    [participantData(9).psychData(3).data]; % + [participantData(10).psychData(3).data];

averageChangepoint = allChangepointData./(length(participantCodes));
averageChangepointThres = averageChangepoint(:, 1);
averageChangepointSlopes = averageChangepoint(:,2);

figure
bar(averageChangepointThres, 'r');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean threshold across participants (% change at point of change)');

figFileName = 'Average_speed_change_changepoint_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

figure
bar(averageChangepointSlopes, 'b');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean slope across participants (% change at point of change)');

figFileName = 'Average_speed_change_changepoint_Slopes';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

%adding all speed_change_changepoint_less values from each participant
allChangepointLessData = [participantData(1).psychData(4).data] + [participantData(2).psychData(4).data] ...
    + [participantData(3).psychData(4).data] + [participantData(4).psychData(4).data] + ...
    [participantData(5).psychData(4).data] + [participantData(6).psychData(4).data] + ...
    [participantData(7).psychData(4).data] + [participantData(8).psychData(4).data] + ...
    [participantData(9).psychData(4).data]; % + [participantData(10).psychData(4).data];

averageChangepointLess = allChangepointLessData./(length(participantCodes));
averageChangepointLessThres = averageChangepointLess(:, 1);
averageChangepointLessSlopes = averageChangepointLess(:,2);

figure
bar(averageChangepointLessThres, 'r');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean threshold across participants with 6/7 levels (% change at point of change)');

figFileName = 'Average_speed_change_changepoint_less_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

figure
bar(averageChangepointLessSlopes, 'b');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean slope across participants with 6/7 levels (% change at point of change)');

figFileName = 'Average_speed_change_changepoint_less_Slopes';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

%adding all speed_change_start_end values from each participant
allStartEndData = [participantData(1).psychData(5).data] + [participantData(2).psychData(5).data] ...
    + [participantData(3).psychData(5).data] + [participantData(4).psychData(5).data] + ...
    [participantData(5).psychData(5).data] + [participantData(6).psychData(5).data] + ...
    [participantData(7).psychData(5).data] + [participantData(8).psychData(5).data] + ...
    [participantData(9).psychData(5).data]; % + [participantData(10).psychData(5).data];

averageStartEnd = allStartEndData./(length(participantCodes));
averageStartEndThres = averageStartEnd(:, 1);
averageStartEndSlopes = averageStartEnd(:,2);

figure
bar(averageStartEndThres, 'r');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean threshold across participants (% change over full interval)');

figFileName = 'Average_speed_change_start_end_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

figure
bar(averageStartEndSlopes, 'b');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean slope across participants (% change over full interval)');

figFileName = 'Average_speed_change_start_end_Slopes';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

%adding all speed_change_start_end_less values from each participant
allStartEndLessData = [participantData(1).psychData(6).data] + [participantData(2).psychData(6).data] ...
    + [participantData(3).psychData(6).data] + [participantData(4).psychData(6).data] + ...
    [participantData(5).psychData(6).data] + [participantData(6).psychData(6).data] + ...
    [participantData(7).psychData(6).data] + [participantData(8).psychData(6).data] + ...
    [participantData(9).psychData(6).data]; % + [participantData(10).psychData(6).data];

averageStartEndLess = allStartEndLessData./(length(participantCodes));
averageStartEndLessThres = averageStartEndLess(:, 1);
averageStartEndLessSlopes = averageStartEndLess(:,2);

figure
bar(averageStartEndLessThres, 'r');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean threshold across participants with 6/7 levels (% change over full interval)');

figFileName = 'Average_speed_change_start_end_less_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

figure
bar(averageStartEndLessSlopes, 'b');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',13);
xlabel('Condition');
ylabel('Mean slope across participants with 6/7 levels (% change over full interval)');

figFileName = 'Average_speed_change_start_end_less_Slopes';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0')

