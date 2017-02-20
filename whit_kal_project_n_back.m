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
        
        estimate_initial_time_point = 0;%define value for first Xhat
        
        estimate(1) = estimate_initial_time_point; % tell matlab that the first Xhat
        distal_initial_time_point = 1;
        
        %estimate = estimate+gain*value - estimate;
        
        
        for i= 5:length (stimOri);
            
             err(i) = minAngleDiff(respOri(i), stimOri(i));%whitney
             RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
             RO_n_back1(i)= minAngleDiff (stimOri(i-2),stimOri (i));
             RO_n_back2(i) = minAngleDiff (stimOri(i-3), stimOri(i));
             RO_n_back3(i)= minAngleDiff (stimOri(i-4), stimOri(i));
             
        end
        
        
        err = err(2:end);
        RO  = RO(2:end);
        RO_n_back1(2:end);
        RO_n_back2(2:end);
        RO_n_back3(2:end);
             
             
        figure(100+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter (RO, err,40,'k','filled');
        %add a regresion line
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO, err);
        whitneySD(iParticipant,iCond).r = r(1,2);
        whitneySD(iParticipant,iCond).p = p(1,2);
        %calyculate regression slopes
        myModel = cat(1,RO,ones(size(RO)))';
        myY     = err';
        [b bint] = regress(myY, myModel);
        whitneyFit(iParticipant,iCond).b = b;
        whitneyFit(iParticipant,iCond).bint = bint;
        whitneySlope(iParticipant,iCond) = b(1);
        whitneySlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(whitneySD(iParticipant,iCond).r) ...
            ' p: ' num2str(whitneySD(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared to previous trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_fischerSD'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        figure(100+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter (RO_n_back1, err, 40,'k','filled');
        %add a regresion line
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO_n_back1, err);
        whitney_n_back1(iParticipant,iCond).r = r(1,2);
        whitney_n_back1(iParticipant,iCond).p = p(1,2);
        %calyculate regression slopes
        myModel = cat(1,RO_n_back1,ones(size(RO)))';
        myY     = err';
        [b bint] = regress(myY, myModel);
        whitney_n_back1_Fit(iParticipant,iCond).b = b;
        whitney_n_back1_Fit(iParticipant,iCond).bint = bint;
        whitney_n_back1_Slope(iParticipant,iCond) = b(1);
        whitney_nback_1_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        
    end
end
        
        
       
        
             
             
             
            
            
            