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

scatter (stimOri, whitney_err_unwrap,6);
hold on
Xline = linspace (-60,60, 10);
yHat = b*Xline+mean(whitney_err_unwrap);
ROnew  = linspace(-70,70,50);
[WE_mean, WE_StdErr] = windowAverageUnevenData( RO,whitney_err_unwrap,ROnew,12);

WE_mean(isnan(WE_mean))=0;
WE_StdErr(isnan(WE_StdErr)) = 0;
plot(ROnew, WE_mean)

createShadedRegion(ROnew,WE_mean,...
    WE_mean-WE_StdErr,WE_mean+WE_StdErr,...
     'linewidth', 4);



%plot (Xline, yHat,'LineWidth',8);
axis([-40,40,-30,30]);
%line([-90 90], [-90 90],'linewidth', 10);
box off
hold on
%legend ('Participant error (deg) vs relative orientation(deg)');
xlabel('stimOri(deg)');
ylabel('Participant error on current trial (deg)');


    end
end