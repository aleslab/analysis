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

    



for i= 2:length (respOri);
    

whitney_err(i) = minAngleDiff(respOri(i), stimOri(i)); %whitney error
    
RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney/relative orientation


   

end

%[ b, bint, r, p ] = analysis_func ( RO, whitney_err);
[b,~,~,~, whitney_err_unwrap] = circularSlope90d(whitney_err, RO);

figure(102+iParticipant);
%clf;
%whitey plot
set(gca,'fontsize', 28);


Xline = linspace (-35,35, 8);
yHat = b*Xline+mean(whitney_err_unwrap);
ROnew  = linspace(-35,35,50);
[Whitney_err_mean, Whitney_err_StdErr] = windowAverageUnevenData( RO,whitney_err_unwrap,ROnew,12);


allPartROnew (:,iCond,iParticipant)=(ROnew);
allPartErrUnwrap (:,iCond,iParticipant)=Whitney_err_mean;



    end
end



figure (201);clf
N=ptbCorgiData.nParticipants;
stderrmean=nanstd(allPartErrUnwrap,[],3)/sqrt(N);
err_mean=nanmean(allPartErrUnwrap,3);
RO_mean= nanmean(allPartROnew,3);
plot(RO_mean, err_mean)


%cond1
createShadedRegion(RO_mean(:,1),err_mean(:,1),...
    err_mean(:,1)-stderrmean(:,1),err_mean(:,1)+stderrmean(:,1),...
     'linewidth', 4);
hold on;

 createShadedRegion(RO_mean(:,2),err_mean(:,2),...
    err_mean(:,2)-stderrmean(:,2),err_mean(:,2)+stderrmean(:,2),...
     'linewidth', 4);

 