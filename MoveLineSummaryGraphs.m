
participantCodes = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J' 'K'}; 

analysisType = {'speed_change_changepoint', 'speed_change_changepoint_arcmin', ...
    'speed_change_full', 'speed_change_full_arcmin', 'start_arcmin', 'end_arcmin'};

%for the code to work properly later, these need to be in the order:
%1. 'speed_change_changepoint'
%2. 'speed_change_changepoint_arcmin'
%3. 'speed_change_full'
%4. 'speed_change_full_arcmin'
%5. 'start_arcmin'
%6. 'end_arcmin'
    
% conditionList = {'MoveLine_accelerating_depth_midspeed'; ...
%     'MoveLine_accelerating_depth_slow'; 'MoveLine_accelerating_lateral_midspeed'; ...
%     'MoveLine_accelerating_lateral_slow'; 'MoveLine_CRS_depth_midspeed'; ...
%     'MoveLine_CRS_depth_slow'; 'MoveLine_CRS_lateral_midspeed'; 'MoveLine_CRS_lateral_slow'};

%these conditions are abbreviated here:
shortenedCondList = {'ADF' 'ADS' 'ALF' 'ALS' 'CRSDF' 'CRSDS' 'CRSLF' 'CRSLS'};

for iParticipant = 1:length(participantCodes)
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    for iAnalysis = 1:length(analysisType)
        currAnalysisType = cell2mat(analysisType(iAnalysis));
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
        
        %this allows you to specify the size that the figure will be
        %printed as in a pdf, rather than just the default.
        fig = gcf; %you say fig is the current figure handle
        fig.PaperUnits = 'inches'; %say the paper units are inches
        fig.PaperPosition = [0 5 8.5 5.5]; %you then specify the x and y
        %starting coordinates of the graph on the paper followed by the
        %size in inches of the graph
        print(thresholdfigFileName,'-dpdf','-r0') %this prints the current
        %figure with the specified size to the name in slopesfigFileName as
        %a pdf.
        
        hold off
       
        
        psychData(iAnalysis).data = usefulPsychData;
        
    end
    
    participantData(iParticipant).psychData = psychData;
end

%close all;

%% speed_change_changepoint (proportion) analysis

allChangepointData = [[participantData(1).psychData(1).data(:,1)] [participantData(2).psychData(1).data(:,1)] ...
    [participantData(3).psychData(1).data(:,1)] [participantData(4).psychData(1).data(:,1)] ...
    [participantData(5).psychData(1).data(:,1)] [participantData(6).psychData(1).data(:,1)] ...
    [participantData(7).psychData(1).data(:,1)] [participantData(8).psychData(1).data(:,1)] ...
    [participantData(9).psychData(1).data(:,1)] [participantData(10).psychData(1).data(:,1)]];

allChangepointDataTable = array2table(allChangepointData);

writetable(allChangepointDataTable, 'allChangePointThresholds.csv');

%all individual conditions
cADM = allChangepointData(1,:); %ALL ADM for changepoint
cADS = allChangepointData(2,:);
cALM = allChangepointData(3,:);
cALS = allChangepointData(4,:);
cCRSDM = allChangepointData(5,:);
cCRSDS = allChangepointData(6,:);
cCRSLM = allChangepointData(7,:);
cCRSLS = allChangepointData(8,:);

%for every condition main graph
%averages
avecADM = mean(cADM); %ALL ADM means for changepoint
avecADS = mean(cADS);
avecALM = mean(cALM);
avecALS = mean(cALS);
avecCRSDM = mean(cCRSDM);
avecCRSDS = mean(cCRSDS);
avecCRSLM = mean(cCRSLM);
avecCRSLS = mean(cCRSLS);

%[h, p] = ttest2(cCRSLS, cCRSLM);

allChangepointAverages = [avecADM avecADS avecALM avecALS avecCRSDM avecCRSDS avecCRSLM avecCRSLS];

%sems

semcADM = std(cADM)/sqrt(length(cADM));
semcADS = std(cADS)/sqrt(length(cADS));
semcALM = std(cALM)/sqrt(length(cALM));
semcALS = std(cALS)/sqrt(length(cALS));
semcCRSDM = std(cCRSDM)/sqrt(length(cCRSDM));
semcCRSDS = std(cCRSDS)/sqrt(length(cCRSDS));
semcCRSLM = std(cCRSLM)/sqrt(length(cCRSLM));
semcCRSLS = std(cCRSLS)/sqrt(length(cCRSLS));

allChangepointSEMs = [semcADM semcADS semcALM semcALS semcCRSDM semcCRSDS semcCRSLM semcCRSLS];

figure
hold on
bar(allChangepointAverages, 'r');
errorbar(allChangepointAverages, allChangepointSEMs, '.k');
set(gca, 'XTick', 1:1:8);
set(gca, 'XTickLabel', shortenedCondList);
set(gca, 'fontsize',14);
ylim([0 0.5]);
xlabel('Condition');
ylabel('Mean thresholds (proportion)');

figFileName = 'Average_speed_change_changepoint_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0');

hold off 

% 3 way repeated measures anova graph for changepoint proportion
%for main effect graphs from 3RMANOVA
allAccel = horzcat(cADM, cADS, cALM, cALS);
allCRS = horzcat(cCRSDM, cCRSDS, cCRSLM, cCRSLS);
allDepth = horzcat(cADM, cADS, cCRSDM, cCRSDS);
allLateral = horzcat(cALM, cALS, cCRSLM, cCRSLS);
allFast = horzcat(cADM, cALM, cCRSDM, cCRSLM);
allSlow = horzcat(cADS, cALS, cCRSDS, cCRSLS);

%means of groupings from 3RMANOVA
meanAllCRS = mean(allCRS);

meanAllAccel = mean(allAccel);

meanAllDepth = mean(allDepth);

meanAllLateral = mean(allLateral);

meanAllFast = mean(allFast);

meanAllSlow = mean(allSlow);

allNames = {'Accel'; 'CRS'; 'Depth'; 'Lateral'; 'Fast'; 'Slow'};
allMeans = [meanAllAccel; meanAllCRS; meanAllDepth; meanAllLateral; meanAllFast; meanAllSlow];

%confidence interval calculations

MSw = (0.187 + 0.182 + 0.025 + 0.092 + 0.067 + 0.013 +0.012)/63; 
%sum of all type III sum of square errors divided by the sum of their degrees of freedom

tValue = tinv(0.975, 63); % the value from the t distribution to use for getting repeated measures confidence intervals

CIaddValue = (sqrt(MSw/10)).*tValue; %final confidence interval values are the mean +/- this value


%AvC
AvCmeans = [meanAllAccel meanAllCRS];

figure
hold on
bar(AvCmeans, 0.5, 'r');
errorbar(AvCmeans, [CIaddValue, CIaddValue], '.k');

set(gca, 'XTick', 1:1:2);
set(gca, 'XTickLabel', {'Accelerating' 'Constant retinal speed'});
set(gca, 'fontsize',17);
ylim([0 0.5]);
ylabel('Mean thresholds (proportion)');

figFileName = 'AvC_graph';
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
ylim([0 0.5]);
ylabel('Mean thresholds (proportion)');

figFileName = 'DvL_graph';
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
ylim([0 0.5]);
ylabel('Mean thresholds (proportion)');

figFileName = 'FvS_graph';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 5.5 5.5];
print(figFileName,'-dpdf','-r0');

hold off

%interaction effects from 3RMANOVA

bothDepthSlow = horzcat(cADS, cCRSDS);
bothDepthFast = horzcat(cADM, cCRSDM);
bothLateralSlow = horzcat(cALS, cCRSLS);
bothLateralFast = horzcat(cALM, cCRSLM);

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
ylim([0 0.5]);
ylabel('Mean thresholds (proportion)');

figFileName = 'slowfast_interaction_graph';
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
ylim([0 0.5]);
ylabel('Mean thresholds (proportion)');

figFileName = 'depthlateral_interaction_graph';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 5.5 5.5];
print(figFileName,'-dpdf','-r0');

hold off

%% speed_change_changepoint_arcmin analysis