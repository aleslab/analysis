ptbCorgiData = uiGetPtbCorgiData();

%Set some figure options:
figurePosition = [0 0 1000 500];

%JMA: Next let's loop through each participant and each condition.
%
for iParticipant = 1 : ptbCorgiData.nParticipants,
    
    %JMA: get the data for this participant.
    sortedData = ...
        ptbCorgiData.participantData(iParticipant).sortedTrialData;
    thisParticipantId = ptbCorgiData.participantList{iParticipant};
    
    for iCond  = 1 : ptbCorgiData.nConditions,
   
        thisConditionLabel = ptbCorgiData.conditionInfo(iCond).label;
        thisLabel = [ thisParticipantId '-' thisConditionLabel]; 
        %JMA: Now pull out the fields we need from the trialData
        respOri = [sortedData(iCond).trialData(:).respOri];
        stimOri = [sortedData(iCond).trialData(:).stimOri];
        




    
respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);

    
part_PR_Err(1)=0;
participant_update (1)=0;

allPartErr (1)=0;
allPartUpdate (1)=0;

for i= 2:length (stimOri);
    

part_PE_Err(i) = minAngleDiff(stimOri(i), respOri(i-1)); 
    
participant_update(i)=  minAngleDiff (respOri(i),respOri (i-1));

allPartErr (:,iCond,iParticipant)=mean(part_PE_Err,2);
allPartUpdate (:,iCond,iParticipant)=mean(participant_update, 2);

end

%[ b, bint, r, p ] = analysis_func ( RO, whitney_err);
%[b,~,~,~,allPartErr] = circularSlope90d(part_PE_Err, participant_update);

figure(102+iParticipant);clf
%clf;
%whitey plot
set(gca,'fontsize', 28);

scatter (allPartErr, allPartUpdate,4);

    end
    
end
% hold on
% Xline = linspace (-35,35, 8);
% yHat = b*Xline+mean(part_PE_Err);
% part_Pe_new  = linspace(-35,35,50);
% [WE_mean, WE_StdErr] = windowAverageUnevenData(participant_update ,part_PE_Err,part_Pe_new,12);
% 
% WE_mean(isnan(WE_mean))=0;
% WE_StdErr(isnan(WE_StdErr)) = 0;
% plot(part_Pe_new, WE_mean)
% 
% createShadedRegion(part_Pe_new,WE_mean,...
%     WE_mean-WE_StdErr,WE_mean+WE_StdErr,...
%      'linewidth', 4);
% 
% %plot (Xline, yHat,'LineWidth',8);
% axis([-90,90,-90,90]);
% line([-90 90], [-90 90],'linewidth', 10);
% box off
% hold on
% legend ('Participant error (deg) vs relative orientation(deg)');
% xlabel('Relative orientation of current trial compared to previous trial(deg)');
% ylabel('Participant error on current trial (deg)');
% 
% 
%     end
% end