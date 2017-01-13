
participantCodes = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J' 'K'};

analysisType = {'speed_change_changepoint', 'speed_change_changepoint_arcmin', ... %'start_arcmin' 'end_arcmin' currently problems with the start one
    'speed_change_full', 'speed_change_full_arcmin'};
%for the code to work properly later, these need to be in the order:
%1. 'speed_change_changepoint'
%2. 'speed_change_changepoint_arcmin'
%3. 'speed_change_full'
%4. 'speed_change_full_arcmin'
%5. 'end_arcmin'

% conditionList = {'MoveLine_accelerating_depth_midspeed'; ...
%     'MoveLine_accelerating_depth_slow'; 'MoveLine_accelerating_lateral_midspeed'; ...
%     'MoveLine_accelerating_lateral_slow'; 'MoveLine_CRS_depth_midspeed'; ...
%     'MoveLine_CRS_depth_slow'; 'MoveLine_CRS_lateral_midspeed'; 'MoveLine_CRS_lateral_slow'};

%these conditions are abbreviated here:
shortenedCondList = {'ADF' 'ADS' 'ALF' 'ALS' 'CRSDF' 'CRSDS' 'CRSLF' 'CRSLS'};

for iParticipant = 1:length(participantCodes)
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    for iAnalysis2 = 1:length(analysisType)
        currAnalysisType = cell2mat(analysisType(iAnalysis2));
        filename = strcat('/Users/Abigail/Documents/Experiment Data/Experiment 1/Participant_', ...
            currParticipantCode, '/Analysis/', currAnalysisType,'/psychometric_data_',...
            currAnalysisType,'_', currParticipantCode, '.csv');
        
        allPsychData = csvread(filename, 1, 1);
        usefulPsychData = allPsychData(:, 1:7); %Currently only interested
        %in what's in columns 1, 3, 4 and 7. These information about the thresholds.
        
        %threshold information
        thresholds = usefulPsychData(:,1);
        thresholdLowerCI = usefulPsychData(:,3);
        thresholdUpperCI = usefulPsychData(:,4);
        thresholdLowerCIsize = thresholds - thresholdLowerCI;
        thresholdUpperCIsize = thresholdUpperCI - thresholds;
        thresholdSE = usefulPsychData(:,7);
        
        %         figure
        %         hold on
        %         bar(thresholds, 'r');
        %         errorbar(1:1:8, thresholds, thresholdLowerCIsize, thresholdUpperCIsize, '.k');
        %         grid on
        %         set(gca, 'XTick', 1:1:8);
        %         set(gca, 'XTickLabel', shortenedCondList);
        %         set(gca, 'fontsize',13);
        %         xlabel('Condition');
        %         ylabel('75% threshold');
        %         thresholdTitle = strcat('Threshold_', currAnalysisType, '_', currParticipantCode);
        %         title(thresholdTitle, 'interpreter', 'none');
        %
        %         thresholdfigFileName = strcat('threshold_summary_graph_', currAnalysisType, '_', currParticipantCode, '.pdf');
        %
        %         %this allows you to specify the size that the figure will be
        %         %printed as in a pdf, rather than just the default.
        %         fig = gcf; %you say fig is the current figure handle
        %         fig.PaperUnits = 'inches'; %say the paper units are inches
        %         fig.PaperPosition = [0 5 8.5 5.5]; %you then specify the x and y
        %         %starting coordinates of the graph on the paper followed by the
        %         %size in inches of the graph
        %         print(thresholdfigFileName,'-dpdf','-r0') %this prints the current
        %         %figure with the specified size to the name in slopesfigFileName as
        %         %a pdf.
        %
        %         hold off
        
        psychData(iAnalysis2).data = usefulPsychData;
        
    end
    
    participantData(iParticipant).psychData = psychData;
    
end

for iAnalysis = 1:length(analysisType)
    currAnalysisType = cell2mat(analysisType(iAnalysis));
    
    allData = [[participantData(1).psychData(iAnalysis).data(:,1)] [participantData(2).psychData(iAnalysis).data(:,1)] ...
        [participantData(3).psychData(iAnalysis).data(:,1)] [participantData(4).psychData(iAnalysis).data(:,1)] ...
        [participantData(5).psychData(iAnalysis).data(:,1)] [participantData(6).psychData(iAnalysis).data(:,1)] ...
        [participantData(7).psychData(iAnalysis).data(:,1)] [participantData(8).psychData(iAnalysis).data(:,1)] ...
        [participantData(9).psychData(iAnalysis).data(:,1)] [participantData(10).psychData(iAnalysis).data(:,1)]];
    
    allDataTable = array2table(allData);
    
    filename = char(strcat('all_', currAnalysisType, '_thresholds.csv'));
    writetable(allDataTable, filename);
    
    %all individual conditions
    ADM = allData(1,:); %ALL ADM for changepoint
    ADS = allData(2,:);
    ALM = allData(3,:);
    ALS = allData(4,:);
    CRSDM = allData(5,:);
    CRSDS = allData(6,:);
    CRSLM = allData(7,:);
    CRSLS = allData(8,:);
    
    %for every condition main graph
    %averages
    aveADM = mean(ADM); %ALL ADM means for changepoint
    aveADS = mean(ADS);
    aveALM = mean(ALM);
    aveALS = mean(ALS);
    aveCRSDM = mean(CRSDM);
    aveCRSDS = mean(CRSDS);
    aveCRSLM = mean(CRSLM);
    aveCRSLS = mean(CRSLS);
    
    allAverages = [aveADM aveADS aveALM aveALS aveCRSDM aveCRSDS aveCRSLM aveCRSLS];
    
    %sems
    
    semADM = std(ADM)/sqrt(length(ADM));
    semADS = std(ADS)/sqrt(length(ADS));
    semALM = std(ALM)/sqrt(length(ALM));
    semALS = std(ALS)/sqrt(length(ALS));
    semCRSDM = std(CRSDM)/sqrt(length(CRSDM));
    semCRSDS = std(CRSDS)/sqrt(length(CRSDS));
    semCRSLM = std(CRSLM)/sqrt(length(CRSLM));
    semCRSLS = std(CRSLS)/sqrt(length(CRSLS));
    
    allSEMs = [semADM semADS semALM semALS semCRSDM semCRSDS semCRSLM semCRSLS];
    
    
    figure
    hold on
    bar(allAverages, 'r');
    errorbar(allAverages, allSEMs, '.k');
    set(gca, 'XTick', 1:1:8);
    set(gca, 'XTickLabel', shortenedCondList);
    set(gca, 'fontsize',14);
    xlabel('Condition');
    
    if strcmp(currAnalysisType, 'speed_change_changepoint') || strcmp(currAnalysisType, 'speed_change_full');
        
        ylabel('Mean thresholds (proportion)');
        ylim([0 0.5])
        
    elseif strcmp(currAnalysisType, 'speed_change_changepoint_arcmin') || strcmp(currAnalysisType, 'speed_change_full_arcmin');
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 30])
        
    else
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 100])
        
    end
    
    title(currAnalysisType, 'interpreter', 'none');
    
    figFileName = char(strcat('means_', currAnalysisType, '_thresholds'));
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 4 8.5 5.5];
    print(figFileName,'-dpdf','-r0');
    
    hold off
    
    %for main effect graphs from 3RMANOVA
    allAccel = horzcat(ADM, ADS, ALM, ALS);
    allCRS = horzcat(CRSDM, CRSDS, CRSLM, CRSLS);
    allDepth = horzcat(ADM, ADS, CRSDM, CRSDS);
    allLateral = horzcat(ALM, ALS, CRSLM, CRSLS);
    allFast = horzcat(ADM, ALM, CRSDM, CRSLM);
    allSlow = horzcat(ADS, ALS, CRSDS, CRSLS);
    
    % means of groupings from 3RMANOVA on speed_change_changepoint (proportion)
    meanAllCRS = mean(allCRS);
    
    meanAllAccel = mean(allAccel);
    
    meanAllDepth = mean(allDepth);
    
    meanAllLateral = mean(allLateral);
    
    meanAllFast = mean(allFast);
    
    meanAllSlow = mean(allSlow);
    
    allNames = {'Accel'; 'CRS'; 'Depth'; 'Lateral'; 'Fast'; 'Slow'};
    allMeans = [meanAllAccel; meanAllCRS; meanAllDepth; meanAllLateral; meanAllFast; meanAllSlow];
    mainEffectMeansTable = table(allNames, allMeans);
    
       filename = char(strcat('all_', currAnalysisType, '_main_effect_means.csv'));
    writetable(mainEffectMeansTable, filename);
    
    %confidence interval calculations
    
    MSw = [((0.187 + 0.182 + 0.025 + 0.092 + 0.067 + 0.013 +0.012)/63),... %changepoint proportion
        ((413.338 + 409.460 + 206.729 + 228.219 + 215.405 + 53.635 + 67.380)/63), ... %changepoint arcmin/s
        ((0.140 + 0.143 + 0.017 + 0.072 + 0.054 + 0.010 +0.010)/63), ... %full interval proportion
        ((699.458 + 641.066 + 349.107 + 394.647 + 334.756 + 82.853 + 113.736)/63)]; %full interval arcmin/s
    %sum of all type III sum of square errors divided by the sum of their degrees of freedom
    
    tValue = tinv(0.975, 63); % the value from the t distribution to use for getting repeated measures confidence intervals
    
    CIaddValue = (sqrt(MSw(iAnalysis)/10)).*tValue; %final confidence interval values are the mean +/- this value
    
    
    %AvC
    AvCmeans = [meanAllAccel meanAllCRS];
    
    figure
    hold on
    bar(AvCmeans, 0.5, 'r');
    errorbar(AvCmeans, [CIaddValue, CIaddValue], '.k');
    
    set(gca, 'XTick', 1:1:2);
    set(gca, 'XTickLabel', {'Accelerating' 'Constant retinal speed'});
    set(gca, 'fontsize',17);
    
    if strcmp(currAnalysisType, 'speed_change_changepoint') || strcmp(currAnalysisType, 'speed_change_full');
        
        ylabel('Mean thresholds (proportion)');
        ylim([0 0.5])
        
    elseif strcmp(currAnalysisType, 'speed_change_changepoint_arcmin') || strcmp(currAnalysisType, 'speed_change_full_arcmin');
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 30])
        
    else
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 100])
        
    end
    
    title(currAnalysisType, 'interpreter', 'none');
    
    figFileName = char(strcat(currAnalysisType, 'AvC_graph'));
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 4 5.5 5.5];
    print(figFileName,'-dpdf','-r0');
    
    hold off
    
    %DvL
    
    DvLmeans = [meanAllDepth meanAllLateral];
    
    figure
    hold on
    bar(DvLmeans, 0.5, 'r');
    errorbar(DvLmeans, [CIaddValue, CIaddValue], '.k');
    
    set(gca, 'XTick', 1:1:2);
    set(gca, 'XTickLabel', {'Depth' 'Lateral'});
    set(gca, 'fontsize',17);
    if strcmp(currAnalysisType, 'speed_change_changepoint') || strcmp(currAnalysisType, 'speed_change_full');
        
        ylabel('Mean thresholds (proportion)');
        ylim([0 0.5])
        
    elseif strcmp(currAnalysisType, 'speed_change_changepoint_arcmin') || strcmp(currAnalysisType, 'speed_change_full_arcmin');
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 30])
        
    else
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 100])
        
    end
    
    title(currAnalysisType, 'interpreter', 'none');
    
    figFileName = char(strcat(currAnalysisType, 'DvL_graph'));
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 4 5.5 5.5];
    print(figFileName,'-dpdf','-r0');
    
    hold off
    
    %FvS
    
    FvSmeans = [meanAllFast meanAllSlow];
    
    figure
    hold on
    bar(FvSmeans, 0.5, 'r');
    errorbar(FvSmeans, [CIaddValue, CIaddValue], '.k');
    
    set(gca, 'XTick', 1:1:2);
    set(gca, 'XTickLabel', {'Fast speed' 'Slow speed'});
    set(gca, 'fontsize',17);
    if strcmp(currAnalysisType, 'speed_change_changepoint') || strcmp(currAnalysisType, 'speed_change_full');
        
        ylabel('Mean thresholds (proportion)');
        ylim([0 0.5])
        
    elseif strcmp(currAnalysisType, 'speed_change_changepoint_arcmin') || strcmp(currAnalysisType, 'speed_change_full_arcmin');
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 30])
        
    else
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 100])
        
    end
    
    
    title(currAnalysisType, 'interpreter', 'none');
    
    figFileName = char(strcat(currAnalysisType, 'FvS_graph'));
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 4 5.5 5.5];
    print(figFileName,'-dpdf','-r0');
    
    hold off
    
    %interaction effects from 3RMANOVA
    
    bothDepthSlow = horzcat(ADS, CRSDS);
    bothDepthFast = horzcat(ADM, CRSDM);
    bothLateralSlow = horzcat(ALS, CRSLS);
    bothLateralFast = horzcat(ALM, CRSLM);
    
    meanDepthSlow = mean(bothDepthSlow);
    meanDepthFast = mean(bothDepthFast);
    meanLateralSlow = mean(bothLateralSlow);
    meanLateralFast = mean(bothLateralFast);
    
    %slow-fast on axis
    sfMeanDepth = [meanDepthSlow, meanDepthFast];
    sfMeanLateral = [meanLateralSlow, meanLateralFast];
    
    figure
    hold on
    errorbar(sfMeanDepth, [CIaddValue, CIaddValue], '-xk');
    errorbar(sfMeanLateral, [CIaddValue, CIaddValue], '-xb');
    legend({'Depth', 'Lateral'});
    set(gca, 'XTick', 1:1:2);
    set(gca, 'XTickLabel', {'Slow' 'Fast'});
    set(gca, 'fontsize',17);
    
    if strcmp(currAnalysisType, 'speed_change_changepoint') || strcmp(currAnalysisType, 'speed_change_full');
        
        ylabel('Mean thresholds (proportion)');
        ylim([0 0.5])
        
    elseif strcmp(currAnalysisType, 'speed_change_changepoint_arcmin') || strcmp(currAnalysisType, 'speed_change_full_arcmin');
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 30])
        
    else
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 100])
        
    end
    
    title(currAnalysisType, 'interpreter', 'none');
    
    figFileName = char(strcat(currAnalysisType, 'slowfast_interaction_graph'));
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 4 5.5 5.5];
    print(figFileName,'-dpdf','-r0');
    
    hold off
    
    %depth-Lateral on axis
    dlMeanSlow = [meanDepthSlow, meanLateralSlow];
    dlMeanFast = [meanDepthFast, meanLateralFast];
    
    figure
    hold on
    errorbar(dlMeanSlow, [CIaddValue, CIaddValue], '-xk');
    errorbar(dlMeanFast, [CIaddValue, CIaddValue], '-xb');
    legend({'Slow', 'Fast'});
    set(gca, 'XTick', 1:1:2);
    set(gca, 'XTickLabel', {'Depth' 'Lateral'});
    set(gca, 'fontsize',17);
    
    if strcmp(currAnalysisType, 'speed_change_changepoint') || strcmp(currAnalysisType, 'speed_change_full');
        
        ylabel('Mean thresholds (proportion)');
        ylim([0 0.5])
        
    elseif strcmp(currAnalysisType, 'speed_change_changepoint_arcmin') || strcmp(currAnalysisType, 'speed_change_full_arcmin');
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 30])
        
    else
        
        ylabel('Mean thresholds (arcmin/s)');
        ylim([0 100])
        
    end
    
    title(currAnalysisType, 'interpreter', 'none');
    
    figFileName = char(strcat(currAnalysisType, 'depthlateral_interaction_graph'));
    
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 4 5.5 5.5];
    print(figFileName,'-dpdf','-r0');
    
    hold off
end