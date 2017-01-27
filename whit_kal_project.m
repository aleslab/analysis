
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
        
        gain = .9;%distal / (distal +proximal);
        %estimate = estimate+gain*value - estimate;
        
        err(1) = 0;
        RO(1)  = 0;
        for i= 2:length (respOri);

            %Response Error from Fischer and Whitney:
            %Difference between participants response and the current
            %stimulus
            err(i) = minAngleDiff(respOri(i), stimOri(i));%whitney
            
            %Reltive Orientation as per Fischer and Whitney:
            %Difference between the current and previous stimulus
            RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
            
            %Next value needed to look for recursive influence that is a
            %hallmark of a Kalman process. To do this we want to know what
            %the "prediction error" is.  We don't have this exactly because
            %we only know what was on the screen, not the noisy signal in the brain
            %. 
            %We are going to treat the participants response as a measure
            %of what the particiapnts "estimate" is. Next, we need to make a
            %prediction.  We don't have access to the participants prediction.
            %So we have to assume one.  For a random walk that we had the best
            %prediction is simply to take the previous estimate and as the
            %prediction. Therefore we are going to compare the previous
            %response with the current stimulus value. 
            PE(i) = minAngleDiff(respOri(i-1),stimOri(i));
                        
            participantUpdate(i) = minAngleDiff(respOri(i), respOri(i-1));
            
            %sdEstimate_err(i)= minAngleDiff(sdEstimate(i),stimOri(i-1));
            
            
            
            % plot (gain, 'r');
            % hold on
            
            
            
            
        end
         
        %now get rid of the first number which is meaningless
        err = err(2:end);
        RO  = RO(2:end);
        PE  = PE(2:end);
        participantUpdate  = participantUpdate(2:end);
        
        
        % figure(101);
        % clf
        % set (gca,'fontsize', 24);
        % hold on
        % plot (respOri,'r', 'Linewidth',3);
        % % hold on
        % % plot (stimOri,'g', 'Linewidth',2);
        % hold on
        % plot (estimate,'k','Linewidth',3);
        % legend ('Participant response','Kalman Prediction');
        % xlabel('Trial number');
        % ylabel ('Orientation (degs)');
        
        
        figure(100+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter (RO, err,40,'k','filled');
        %add a regresion line
        lsline;
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO, err);
        whitneySD(iParticipant,iCond).r = r(1,2);
        whitneySD(iParticipant,iCond).p = p(1,2);
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
    
        
        
        
        figure (200+iParticipant);
        
        if iCond ==1;
            clf;
        end
        subplot(1,ptbCorgiData.nConditions,iCond)

        %RO vs PE plot
        set (gca,'fontsize', 16);
        hold on
        scatter (RO, PE,40,'k','filled');
        axis([-90,90,-90,90]);

             %add a regresion line
        lsline;
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO, PE);
        roPe(iParticipant,iCond).r = r(1,2);
        roPe(iParticipant,iCond).p = p(1,2);
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(roPe(iParticipant,iCond).r) ...
            ' p: ' num2str(roPe(iParticipant,iCond).p) ]});
        
        if iCond ==1
            xlabel ('Relative orientation of current trial compared to previous trial(deg)');
            ylabel('Amount of prediction error on current trial (deg)');
            
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_ROPE'];
        
        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
 
        
        figure (300+iParticipant);
        
        if iCond ==1;
            clf;
        end
        subplot(1,ptbCorgiData.nConditions,iCond)

        %RO vs PE plot
        set (gca,'fontsize', 16);
        hold on
        scatter (PE,participantUpdate,40,'k','filled');
        axis([-90,90,-90,90]);

             %add a regresion line
        lsline;
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO, PE);
        pePu(iParticipant,iCond).r = r(1,2);
        pePu(iParticipant,iCond).p = p(1,2);
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(pePu(iParticipant,iCond).r) ...
            ' p: ' num2str(pePu(iParticipant,iCond).p) ]});
        
        if iCond ==1
            xlabel ('PE (deg)');
            ylabel('participantUpdate (deg)');
            
        end
        thisFilename = [ptbCorgiData.paradigmName ... 
            '_' thisParticipantId '_PEPU'];
        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);

%         figure (104);
%         clf;
%         %kal estimate vs PE
%         set (gca,'fontsize', 24);
%         hold on
%         scatter (estimateUpdate, PE,80,'k','filled');
%         axis([-100,100,-100,100]);
%         hold on
%         legend ('Prediction error (deg) vs Kalman predicition update(deg)');
%         xlabel('How much the Kalman updates its next prediction');
%         ylabel ('Prediction error on  current prediction');
% %         
% %         
%         
%         figure(105);
%         clf;
%         set(gca,'fontsize', 24);
%         hold on
%         scatter (RO, sdEstimate,80,'k','filled');
%         axis([-60,60,-60,60]);
%         legend ('Naive estimate vs Relative orientation');
%         xlabel ('Relative orientation of current trial compared to previous trial(deg)');
%         ylabel('Naive estimate error on current trial (deg)');
%         
%         
%            
        % figure(107);
        % clf;
        % set(gca,'fontsize', 24);
        % hold on
        % scatter (sdEstimate, PE,80,'k','filled');
        % legend ('Prediction error (deg) vs sdUpdate(deg)');
        % xlabel('How much the sd updates the next response (deg)');
        % ylabel ('prediction error on current trial (deg)');
        %
        
    end
end



