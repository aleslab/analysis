
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
        estgain = 0.9;
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
            
            
            %( Response(n) - Stim(n-1) )  = a * ( Stim(n) - Stim(n-1))=resposne_minus_past 
            
            % this is the code for a weighted value of current and past
            % stims with a nominal gain value i made up with the variable
            % est gain as we dont know what our gain values are yet

            response_minus_past(i)  = estgain*minAngleDiff(stimOri(i),stimOri(i-1));
            
            % a bit unsure about this calc but i wanted to compare how
            % resposne minus past might update so i needed some measure of
            % error. decided on minAngleDiff(response_minus_past(i),
            % stimOri(i))??
  
            
            response_minus_past_err(i) = minAngleDiff(response_minus_past(i), stimOri(i));
            
            %this seems quite simple Stim(n) - Stim(n-1) is the stimulus update.
            
            response_minus_update(i) = minAngleDiff(response_minus_past(i),response_minus_past(i-1));
            
            
            
            
            
            
            
        end
         
        %now get rid of the first number which is meaningless
        err = err(2:end);
        RO  = RO(2:end);
        PE  = PE(2:end);
        participantUpdate  = participantUpdate(2:end);
        response_minus_past=response_minus_past(2:end);
        response_minus_update=response_minus_update(2:end);
        response_minus_past_err=response_minus_past_err(2:end);
        
        
        
        
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

        %PE vs participantUpdate
        set (gca,'fontsize', 16);
        hold on
        scatter (PE,participantUpdate,40,'k','filled');
        axis([-90,90,-90,90]);

             %add a regresion line
        lsline;
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(PE, participantUpdate);
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
        
        
        
        
        figure(400+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter (response_minus_update, response_minus_past,40,'k','filled');
        %add a regresion line
        lsline;
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(response_minus_update, response_minus_past);
        minus(iParticipant,iCond).r = r(1,2);
        minus(iParticipant,iCond).p = p(1,2);
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(minus(iParticipant,iCond).r) ...
            ' p: ' num2str(minus(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Minus_past(deg)');
        ylabel('Update (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_minus'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
    
        
        
        figure(500+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter (response_minus_past_err,response_minus_update ,40,'k','filled');
        %add a regresion line
        lsline;
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(response_minus_past_err, response_minus_update );
        minus_err_up(iParticipant,iCond).r = r(1,2);
        minus_err_up(iParticipant,iCond).p = p(1,2);
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(minus_err_up(iParticipant,iCond).r) ...
            ' p: ' num2str(minus_err_up(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('min_update');
        ylabel('min_err (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_minus_err_up'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
    
        

    end
end



