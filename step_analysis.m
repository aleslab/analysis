close all;
clear all;

%JMA: uiPtbCorgiData loads project data
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
        
        err = minAngleDiff(respOri, stimOri);%whitney
        
        reshape_err=reshape(err, 15,[]);
        allPart(:,iCond,iParticipant) = mean(reshape_err,2);
%         
figure
plot (respOri,'k')
hold on
plot(stimOri, 'b')

figure (101+iParticipant)
% plot(reshape_err);

plot(mean(reshape_err, 2));
hold on



    end
end


figure
errorbar(repmat(1:15,4,1)',squeeze(mean(allPart,3)),squeeze(std(allPart,[],3)./sqrt(size(allPart,3))));