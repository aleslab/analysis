close all;
clear all;

%JMA: uiPtbCorgiData loads project data
ptbCorgiData = uiGetPtbCorgiData();
%ptbCorgiData=ptbCorgiLoadData('stepGabor_P1_6_file_cat20171018_162630.mat')
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
        

    end
    
   


figure(501+iParticipant)
clf;
set(gca, 'fontweight', 'bold','fontsize', 32);
hold on
lgndIdx = 1;
all_part_stim_new=linspace(-30, 30, 12);


%This here is for UNEVEN and/or RANDOM data not the evenly spaced step.  
%[reshape_err_mean, reshape_err_StdErr] = windowAverageUnevenData(allPartStim ,reshape_err,all_part_stim_new,12);

%WE just want to take a mean over participants:
allPartMean = mean(allPartResp,3)
%And std error across Participants
allPartStdErr = std(allPartResp,[],3)/sqrt(ptbCorgiData.nParticipants);
%The x-axis should be the trial # not the stimulus
%Getting this from the "allPartResp" matrix:
xVal = [1:size(allPartResp,1)]';
xVal = repmat(xVal,1,size(allPartResp,2));
createShadedRegion(xVal,allPartMean,...
    allPartMean-allPartStdErr, allPartMean+allPartStdErr,...
     'linewidth', 5);

for iCond  = 1 : ptbCorgiData.nConditions,
plot(squeeze(allPartResp(:,iCond,iParticipant)),'linewidth',10);
hold on;
legendLabel{lgndIdx} =  ptbCorgiData.conditionInfo(iCond).label;
lgndIdx = lgndIdx+1;

%plot(mean(respBaselineSubtract, 2),'k','linewidth',3);
xlabel('Error in degrees');
ylabel('Orientation in degrees');
plot (squeeze(allPartStim(:,iCond,iParticipant)),'k','linewidth',8)
legendLabel{lgndIdx} = 'Stimulus';lgndIdx = lgndIdx+1;

 end
 %legend(legendLabel)
 
end

