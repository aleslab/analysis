
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
            
            %These values are to create a plot where the slope is the
            %weight on the current trial, unlike whitney plot which the slope is
            %the weight of the previous trial
            % Rt = a*St * (1-a)*stimOri(i-1)
            ROinv(i)       = minAngleDiff( stimOri(i), stimOri(i-1) );
            errFromPrev(i) = minAngleDiff( respOri(i), stimOri(i-1) );
            
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
            %Resp(i) = Resp(i-1) + k *( stimOri(i) - resp(i-1) );
            PE(i) = minAngleDiff(stimOri(i),respOri(i-1));
            PEinv(i) = minAngleDiff(respOri(i-1),stimOri(i));
                        
            participantUpdate(i) = minAngleDiff(respOri(i), respOri(i-1));
            
            %Now if we want a plot with the weight of the previous trial:
            %Resp(i) - stimOri(i) = gain * (respOri(i-1) - stimOri(i))
            % err = gain * PE
            
            %( Response(n) - Stim(n-1) )  = a * ( Stim(n) - Stim(n-1))=resposne_minus_past 
      
            
            
            
            
            
            
        end
         
        %now get rid of the first number which is meaningless
        err = err(2:end);
        RO  = RO(2:end);
        ROinv = ROinv(2:end);
        errFromPrev = errFromPrev(2:end);
        PE  = PE(2:end);
        participantUpdate  = participantUpdate(2:end);
        PEinv=PEinv(2:end);
       % response_minus_past=response_minus_past(2:end);
        %response_minus_update=response_minus_update(2:end);
        %response_minus_past_err=response_minus_past_err(2:end);
        
        
        
        
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
    
        %This plot is for the getting the weight of the current trial from
        %the slope.
        figure(150+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter (ROinv, errFromPrev,40,'k','filled');
        %add a regresion line
        lsline;
        
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(ROinv, errFromPrev);
        whitneyInvFit(iParticipant,iCond).r = r(1,2);
        whitneyInvFit(iParticipant,iCond).p = p(1,2);
        %calyculate regression slopes
        myModel = cat(1,ROinv,ones(size(ROinv)))';
        myY     = errFromPrev';
        [b bint] = regress(myY, myModel);
        whitneyInvFit(iParticipant,iCond).b = b;
        whitneyInvFit(iParticipant,iCond).bint = bint;
        whitneyInvSlope(iParticipant,iCond) = b(1);
        whitneyInvSlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(whitneyInvFit(iParticipant,iCond).r) ...
            ' p: ' num2str(whitneyInvFit(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation inverse(deg)');
        ylabel('Error on previous  trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_whitInv'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
    
        
        
       
        %Recursive version, slope is weight on past trial
        figure (300+iParticipant);
        
        if iCond ==1;
            clf;
        end
        subplot(1,ptbCorgiData.nConditions,iCond)

        %PE vs participantUpdate
        set (gca,'fontsize', 16);
        hold on
        scatter (PEinv,err,40,'k','filled');
        axis([-90,90,-90,90]);

             %add a regresion line
        lsline;
        
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(PEinv, err);
        peInvErr(iParticipant,iCond).r = r(1,2);
        peInvErr(iParticipant,iCond).p = p(1,2);
       %calculate regression slopes and confidence values
        myModel = cat(1,PEinv,ones(size(PEinv)))';
        myY     = err';
        [b bint] = regress(myY, myModel);
        peInvErrFit(iParticipant,iCond).b = b;
        peInvErrFit(iParticipant,iCond).bint = bint;
        peInvErrSlope(iParticipant,iCond) = b(1);
        peInvErrSlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(peInvErr(iParticipant,iCond).r) ...
            ' p: ' num2str(peInvErr(iParticipant,iCond).p) ]});
        
        if iCond ==1
            xlabel ('Inverse PE (deg)');
            ylabel('Error (deg)');
            
        end
        thisFilename = [ptbCorgiData.paradigmName ... 
            '_' thisParticipantId '_peInv'];
        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        
        %recursive version slope is weight on current trial
        figure (350+iParticipant);
        
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
       %calculate regression slopes and confidence values
        myModel = cat(1,PE,ones(size(PE)))';
        myY     = participantUpdate';
        [b bint] = regress(myY, myModel);
        pePuFit(iParticipant,iCond).b = b;
        pePuFit(iParticipant,iCond).bint = bint;
        pePuSlope(iParticipant,iCond) = b(1);
        pePuSlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(pePu(iParticipant,iCond).r) ...
            ' p: ' num2str(pePu(iParticipant,iCond).p) ]});
        
        if iCond ==1
            xlabel ('PE (deg)');
            ylabel('part Update (deg)');
            
        end
        thisFilename = [ptbCorgiData.paradigmName ... 
            '_' thisParticipantId '_PEPU'];
        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        

    end
end



