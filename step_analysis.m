close all;
clear all;

%JMA: uiPtbCorgiData loads project data
ptbCorgiData = uiGetPtbCorgiData();

%Set some figure options:
figurePosition = [0 0 1000 500];

%JMA: Next let's loop through each participant and each condition.
%%
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
        
        err = minAngleDiff(respOri, stimOri);%whitney
        
        reshape_err=reshape(err, 15,[]);
        stim_reshape = reshape(stimOri,15,[]);
       
        allPart(:,iCond,iParticipant) = mean(reshape_err,2);
        
        stimBaselineSubtract = wrapTo90(bsxfun(@minus,stim_reshape,stim_reshape(1,:)));

        resp_unwrap = (stimBaselineSubtract+reshape_err);
         
        allPartResp(:,iCond,iParticipant) = mean(resp_unwrap,2);
        allPartStim(:,iCond,iParticipant) = stimBaselineSubtract(:,1);
%         
% figure
% plot (respOri,'k')
% hold on
% plot(stimOri, 'b')
% 
% figure (101+iParticipant)
% % plot(reshape_err);
% 
% plot(mean(reshape_err, 2));
% hold on



    end


%%
% 
% figure (500);
% clf
% set (gca,'fontsize', 24, 'LineWidth', 5);
% errorbar(repmat(1:15,4,1)',squeeze(mean(allPart,3)),squeeze(std(allPart,[],3)./sqrt(size(allPart,3))));
% set(gca,'fontsize', 28);

%Done in loop above
% respBaselineSubtract = wrapTo90(bsxfun(@minus,allPartResp,allPartStim(1,:)));
% stimBaselineSubtract= wrapTo90(bsxfun(@minus,allPartStim,allPartStim(1,:)));


figure(501+iParticipant);clf
set(gca,'fontsize', 38);

lgndIdx = 1;
 for iCond  = 1 : ptbCorgiData.nConditions,




plot(squeeze(allPartResp(:,iCond,iParticipant)));
hold on;
legendLabel{lgndIdx} =  ptbCorgiData.conditionInfo(iCond).label;
lgndIdx = lgndIdx+1;
%plot(mean(respBaselineSubtract, 2),'k','linewidth',3);
xlabel('Error in degrees');
ylabel('Orientation in degrees');
plot (squeeze(allPartStim(:,iCond,iParticipant)),'k','linewidth',3)
legendLabel{lgndIdx} = 'Stimulus';lgndIdx = lgndIdx+1;
% figure
% errorbar(repmat(1:15,4,1)',squeeze(mean(allPart,3)),squeeze(std(allPart,[],3)./sqrt(size(allPart,3))));
 end
 legend(legendLabel)
 
 end