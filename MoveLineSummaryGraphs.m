
participantCodes = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J' 'K'}; % 

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

shortenedCondList = {'ADF' 'ADS' 'ALF' 'ALS' 'CRSDF' 'CRSDS' 'CRSLF' 'CRSLS'};

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
%         fig = gcf;
%         fig.PaperUnits = 'inches';
%         fig.PaperPosition = [0 5 8.5 5.5];
%         print(thresholdfigFileName,'-dpdf','-r0')
%         
%         hold off
%         
%         figure
%         hold on
%         bar(slopes, 'b');
%         errorbar(1:1:8, slopes, slopeLowerCIsize, slopeUpperCIsize, '.k');
%         grid on %this puts a grid in the background of your graph to make
%         %it a bit clearer to look at
%         set(gca, 'XTick', 1:1:8);
%         set(gca, 'XTickLabel', shortenedCondList);
%         set(gca, 'fontsize',13);
%         xlabel('Condition');
%         ylabel('Slope at 75% correct');
%         slopeTitle = strcat('Slope_', currAnalysisType, '_', currParticipantCode);
%         title(slopeTitle,'interpreter', 'none');
%         
%         slopesfigFileName = strcat('slopes_summary_graph_', currAnalysisType, '_', currParticipantCode, '.pdf');
%         
%         %this allows you to specify the size that the figure will be
%         %printed as in a pdf, rather than just the default.
%         fig = gcf; %you say fig is the current figure handle
%         fig.PaperUnits = 'inches'; %say the paper units are inches
%         fig.PaperPosition = [0 5 8.5 5.5]; %you then specify the x and y
%         %starting coordinates of the graph on the paper followed by the
%         %size in inches of the graph
%         print(slopesfigFileName,'-dpdf','-r0') %this prints the current
%         %figure with the specified size to the name in slopesfigFileName as
%         %a pdf.
%         
%         hold off
        
        psychData(iAnalysis).data = usefulPsychData;
        
    end
    
    participantData(iParticipant).psychData = psychData;
end

close all;

%% all speed_change_changepoint values from each participant

allChangepointData = [[participantData(1).psychData(3).data(:,1)] [participantData(2).psychData(3).data(:,1)] ...
    [participantData(3).psychData(3).data(:,1)] [participantData(4).psychData(3).data(:,1)] ...
    [participantData(5).psychData(3).data(:,1)] [participantData(6).psychData(3).data(:,1)] ...
    [participantData(7).psychData(3).data(:,1)] [participantData(8).psychData(3).data(:,1)] ...
    [participantData(9).psychData(3).data(:,1)] [participantData(10).psychData(3).data(:,1)]];

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
set(gca, 'fontsize',13);
ylim([0 0.8]);
xlabel('Condition');
ylabel('Mean threshold across participants (proportion change)');

figFileName = 'Average_speed_change_changepoint_Thresholds';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0');

hold off 

%means of means in groupings from 3RMANOVA
meanAllCRS = mean([avecCRSDM avecCRSDS avecCRSLM avecCRSLS]);

meanAllAccel = mean([avecADM avecADS avecALM avecALS]);

meanAllDepth = mean([avecCRSDM avecCRSDS avecADM avecADS]);

meanAllLateral = mean([avecCRSLM avecCRSLS avecALM avecALS]);

meanAllFast = mean([avecCRSDM avecCRSLM avecADM avecALM]);

meanAllSlow = mean([avecCRSDS avecCRSLS avecADS avecALS]);

%sems of means of groupings from 3RMANOVA
semAllCRS = std([avecCRSDM avecCRSDS avecCRSLM avecCRSLS])/sqrt(length([avecCRSDM avecCRSDS avecCRSLM avecCRSLS]));

semAllAccel = std([avecADM avecADS avecALM avecALS])/sqrt(length([avecADM avecADS avecALM avecALS]));

semAllDepth = std([avecCRSDM avecCRSDS avecADM avecADS])/sqrt(length([avecCRSDM avecCRSDS avecADM avecADS]));

semAllLateral = std([avecCRSLM avecCRSLS avecALM avecALS])/sqrt(length([avecCRSLM avecCRSLS avecALM avecALS]));

semAllFast = std([avecCRSDM avecCRSLM avecADM avecALM])/sqrt(length([avecCRSDM avecCRSLM avecADM avecALM]));

semAllSlow = std([avecCRSDS avecCRSLS avecADS avecALS])/sqrt(length([avecCRSDS avecCRSLS avecADS avecALS]));

%AvC
AvCmeans = [meanAllAccel meanAllCRS];
AvCsems = [semAllAccel semAllCRS];

figure
hold on
bar(AvCmeans, 'r');
errorbar(AvCmeans, AvCsems, '.k');

set(gca, 'XTick', 1:1:2);
set(gca, 'XTickLabel', {'Accelerating' 'Constant retinal speed'});
set(gca, 'fontsize',13);
ylim([0 0.4]);
xlabel('group');
ylabel('Mean threshold across group conditions (proportion change)');

figFileName = 'AvC_graph';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0');

hold off

%DvL

DvLmeans = [meanAllDepth meanAllLateral];
DvLsems = [semAllDepth semAllLateral];

figure
hold on
bar(DvLmeans, 'r');
errorbar(DvLmeans, DvLsems, '.k');

set(gca, 'XTick', 1:1:2);
set(gca, 'XTickLabel', {'Depth' 'Lateral'});
set(gca, 'fontsize',13);
ylim([0 0.4]);
xlabel('Group');
ylabel('Mean threshold across group conditions (proportion change)');

figFileName = 'DvL_graph';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0');

hold off

%FvS

FvSmeans = [meanAllFast meanAllSlow];
FvSsems = [semAllFast semAllSlow];

figure
hold on
bar(FvSmeans, 'r');
errorbar(FvSmeans, FvSsems, '.k');

set(gca, 'XTick', 1:1:2);
set(gca, 'XTickLabel', {'Fast speed' 'Slow speed'});
set(gca, 'fontsize',13);
ylim([0 0.4]);
xlabel('Group');
ylabel('Mean threshold across group conditions (proportion change)');

figFileName = 'FvS_graph';
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 4 8.5 5.5];
print(figFileName,'-dpdf','-r0');

hold off

%% adding all speed_change_start_end values from each participant
% 
% allStartEndData = [[participantData(1).psychData(5).data(:,1)] [participantData(2).psychData(5).data(:,1)] ...
%     [participantData(3).psychData(5).data(:,1)] [participantData(4).psychData(5).data(:,1)] ...
%     [participantData(5).psychData(5).data(:,1)] [participantData(6).psychData(5).data(:,1)] ...
%     [participantData(7).psychData(5).data(:,1)] [participantData(8).psychData(5).data(:,1)] ...
%     [participantData(9).psychData(5).data(:,1)] [participantData(10).psychData(5).data(:,1)]];
% 
% allStartEndDataTable = array2table(allStartEndData);
% 
% writetable(allStartEndDataTable, 'allStartEndThresholds.csv');
% 
% %all individual conditions
% seADM = allStartEndData(1,:); %ALL ADM for changepoint
% seADS = allStartEndData(2,:);
% seALM = allStartEndData(3,:);
% seALS = allStartEndData(4,:);
% seCRSDM = allStartEndData(5,:);
% seCRSDS = allStartEndData(6,:);
% seCRSLM = allStartEndData(7,:);
% seCRSLS = allStartEndData(8,:);
% 
% %averages
% aveseADM = mean(seADM); %ALL ADM means for changepoint
% aveseADS = mean(seADS);
% aveseALM = mean(seALM);
% aveseALS = mean(seALS);
% aveseCRSDM = mean(seCRSDM);
% aveseCRSDS = mean(seCRSDS);
% aveseCRSLM = mean(seCRSLM);
% aveseCRSLS = mean(seCRSLS);
% 
% allSEAverages = [aveseADM aveseADS aveseALM aveseALS aveseCRSDM aveseCRSDS aveseCRSLM aveseCRSLS];
% 
% %sems
% 
% semseADM = std(seADM)/sqrt(length(seADM));
% semseADS = std(seADS)/sqrt(length(seADS));
% semseALM = std(seALM)/sqrt(length(seALM));
% semseALS = std(seALS)/sqrt(length(seALS));
% semseCRSDM = std(seCRSDM)/sqrt(length(seCRSDM));
% semseCRSDS = std(seCRSDS)/sqrt(length(seCRSDS));
% semseCRSLM = std(seCRSLM)/sqrt(length(seCRSLM));
% semseCRSLS = std(seCRSLS)/sqrt(length(seCRSLS));
% 
% allSESEMs = [semcADM semcADS semcALM semcALS semcCRSDM semcCRSDS semcCRSLM semcCRSLS];
% 
% figure
% hold on
% bar(allSEAverages, 'g');
% errorbar(allSEAverages, allSESEMs, '.k');
% set(gca, 'XTick', 1:1:8);
% set(gca, 'XTickLabel', shortenedCondList);
% set(gca, 'fontsize',13);
% ylim([0 0.8]);
% xlabel('Condition');
% ylabel('Mean threshold across participants (% change over full interval)');
% 
% figFileName = 'Average_speed_change_start_end_Thresholds';
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 4 8.5 5.5];
% print(figFileName,'-dpdf','-r0')
% 
