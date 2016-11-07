
data = xlsread('allChangePointThresholds'); %columns are participants, rows
%are conditions in the order ADM, ADS, ALM, ALS, CRSDM, CRSDS, CRSLM, CRSLS

%To compare ratios for depth vs lateral for each individual participant,
%we want to do ratios of row 1 vs row 3, 2v4, 5v7 and 6v8

for iParticipant = 1:length(data);
    
    AMratio(iParticipant) = (data(3,iParticipant))./(data(1, iParticipant)); %lateral divided by depth for accelerating midspeed
    ASratio(iParticipant) = (data(4,iParticipant))./(data(2, iParticipant)); %lateral divided by depth for accelerating slow
    CRSMratio(iParticipant) = (data(7,iParticipant))./(data(5, iParticipant)); %lateral divided by depth for CRS midspeed
    CRSSratio(iParticipant) = (data(8,iParticipant))./(data(6, iParticipant)); %lateral divided by depth for CRS slow
    
end

meanAMratio = mean(AMratio);
meanASratio = mean(ASratio);
meanCRSMratio = mean(CRSMratio);
meanCRSSratio = mean(CRSSratio);

semAM = std(AMratio)/sqrt(length(AMratio));
semAS = std(ASratio)/sqrt(length(ASratio));
semCRSM = std(CRSMratio)/sqrt(length(CRSMratio));
semCRSS = std(CRSSratio)/sqrt(length(CRSSratio));

[h1, p1, ci1, stats1] = ttest2(AMratio, ASratio);
[h2, p2, ci2, stats2] = ttest2(CRSMratio, CRSSratio);
[h3, p3, ci3, stats3] = ttest2(AMratio, CRSMratio);
[h4, p4, ci4, stats4] = ttest2(ASratio, CRSSratio);

% %% plots
% 
% figure(1)
% hold on
% bar([meanAMratio, meanASratio], 'r');
% errorbar([meanAMratio, meanASratio], [semAM semAS], '.k')
% 
% set(gca, 'XTick', 1:1:2);
% set(gca, 'XTickLabel', {'AM' 'AS'});
% set(gca, 'fontsize',13);
% ylim([0 1.2]);
% xlabel('Condition');
% ylabel('Mean ratio between depth and lateral');
% title('Accelerating ratios')
% 
% fig1FileName = 'Mean_accelerating_ratios_ratio_then_average';
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 4 8.5 5.5];
% print(fig1FileName,'-dpdf','-r0')
% hold off
% 
% figure(2)
% hold on
% bar([meanCRSMratio, meanCRSSratio], 'b');
% errorbar([meanCRSMratio, meanCRSSratio], [semCRSM semCRSS], '.k')
% 
% set(gca, 'XTick', 1:1:2);
% set(gca, 'XTickLabel', {'CRSM' 'CRSS'});
% set(gca, 'fontsize',13);
% ylim([0 1.2]);
% xlabel('Condition');
% ylabel('Mean ratio between depth and lateral');
% title('CRS ratios')
% 
% fig2FileName = 'Mean_CRS_ratios_ratio_then_average';
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 4 8.5 5.5];
% print(fig2FileName,'-dpdf','-r0')
% 
% hold off
% 
% %accelerating midspeed ratio plot for all participants
% figure(3)
% bar(AMratio, 'r');
% set(gca, 'XTick', 1:1:10);
% set(gca, 'XTickLabel', {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J' 'K'});
% set(gca, 'fontsize',13);
% ylim([0 1.8]);
% xlabel('Participant');
% ylabel('Ratio between depth and lateral');
% title('Accelerating midspeed ratios')
% 
% fig3FileName = 'AM_ratios_all_participants';
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 4 8.5 5.5];
% print(fig3FileName,'-dpdf','-r0')
% 
% %accelerating slow ratio plot for all participants
% figure(4)
% bar(ASratio, 'r');
% set(gca, 'XTick', 1:1:10);
% set(gca, 'XTickLabel', {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J' 'K'});
% set(gca, 'fontsize',13);
% ylim([0 1.8]);
% xlabel('Participant');
% ylabel('Ratio between depth and lateral');
% title('Accelerating slow ratios')
% 
% fig4FileName = 'AS_ratios_all_participants';
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 4 8.5 5.5];
% print(fig4FileName,'-dpdf','-r0')
% 
% %CRS midspeed ratio plot for all participants
% figure(5)
% bar(CRSMratio, 'b');
% set(gca, 'XTick', 1:1:10);
% set(gca, 'XTickLabel', {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J' 'K'});
% set(gca, 'fontsize',13);
% ylim([0 1.8]);
% xlabel('Participant');
% ylabel('Ratio between depth and lateral');
% title('CRS midspeed ratios')
% 
% fig5FileName = 'CRSM_ratios_all_participants';
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 4 8.5 5.5];
% print(fig5FileName,'-dpdf','-r0')
% 
% 
% %CRS slow ratio plot for all participants
% figure(6)
% bar(CRSSratio, 'b');
% set(gca, 'XTick', 1:1:10);
% set(gca, 'XTickLabel', {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'J' 'K'});
% set(gca, 'fontsize',13);
% ylim([0 1.8]);
% xlabel('Participant');
% ylabel('Ratio between depth and lateral');
% title('CRS slow ratios')
% 
% fig6FileName = 'CRSS_ratios_all_participants';
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 4 8.5 5.5];
% print(fig6FileName,'-dpdf','-r0')
