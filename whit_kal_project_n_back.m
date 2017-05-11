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
        
        
        for i= 7:length (stimOri);
            
             err(i) = minAngleDiff(respOri(i), stimOri(i));%whitney
             RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
             RO_n_back_2(i)= minAngleDiff (stimOri(i-2),stimOri (i));
             RO_n_back_3(i) = minAngleDiff (stimOri(i-3), stimOri(i));
             RO_n_back_4(i)= minAngleDiff (stimOri(i-4), stimOri(i));
             RO_n_back_5(i)=minAngleDiff (stimOri(i-5), stimOri(i));
             RO_n_back_6(i)=minAngleDiff(stimOri(i-6), stimOri(i));
             
        end
        
        
        err = err(7:end);
        RO  = RO(7:end);
        RO_n_back_2=RO_n_back_2(7:end);
        RO_n_back_3=RO_n_back_3(7:end);
        RO_n_back_4=RO_n_back_4(7:end);
        RO_n_back_5=RO_n_back_5(7:end);
        %RO_n_back_6=RO_n_back_6(7:end);
             
             
        figure(100+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        
        [ b, bint, r, p ] = analysis_func (RO, err);
        
        
        n_back_1_Fit(iParticipant,iCond).b = b;
        n_back_1_Fit(iParticipant,iCond).bint = bint;
        n_back_1_Slope(iParticipant,iCond) = b(1);
        n_back_1_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        n_back_1_corr(iParticipant,iCond).r = r;
        n_back_1_corr(iParticipant,iCond).p = p;
        
        %Now get 
        scatter (RO, err,40,'k','filled');
        axis([-90,90,-90,90]);
        
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(n_back_1_corr(iParticipant,iCond).r) ...
            ' p: ' num2str(n_back_1_corr(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared to previous trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_fischerSD'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        figure(200+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        [ b, bint, r, p ] = analysis_func (RO_n_back_2, err);
        %whitney plot
        
        n_back_2_corr(iParticipant,iCond).r = r;
        n_back_2_corr(iParticipant,iCond).p = p;
        %calyculate regression slopes
        
        n_back_2_Fit(iParticipant,iCond).b = b;
        n_back_2_Fit(iParticipant,iCond).bint = bint;
        n_back_2_Slope(iParticipant,iCond) = b(1);
        n_back_2_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        scatter (RO_n_back_2, err,40,'k','filled');
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(n_back_2_corr(iParticipant,iCond).r) ...
            ' p: ' num2str(n_back_2_corr(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared to the n-2 trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_n-2 corr'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        
       
        figure(300+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
       
        
        [ b, bint, r, p ] = analysis_func (RO_n_back_3, err);
        
        n_back_3_corr(iParticipant,iCond).r = r;
        n_back_3_corr(iParticipant,iCond).p = p;
        
        n_back_3_Fit(iParticipant,iCond).b = b;
        n_back_3_Fit(iParticipant,iCond).bint = bint;
        n_back_3_Slope(iParticipant,iCond) = b(1);
        n_back_3_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        scatter (RO_n_back_3, err,40,'k','filled');
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(n_back_3_corr(iParticipant,iCond).r) ...
            ' p: ' num2str(n_back_3_corr(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared n-3 trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_n-3 corr'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        figure(400+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        
        [ b, bint, r, p ] = analysis_func (RO_n_back_4,err);
        
        
        n_back_4_Fit(iParticipant,iCond).b = b;
        n_back_4_Fit(iParticipant,iCond).bint = bint;
        n_back_4_Slope(iParticipant,iCond) = b(1);
        n_back_4_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        n_back_4_corr(iParticipant,iCond).r = r;
        n_back_4_corr(iParticipant,iCond).p = p;
        
        %Now get 
        scatter (RO_n_back_4, err,40,'k','filled');
        axis([-90,90,-90,90]);
        
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(n_back_1_corr(iParticipant,iCond).r) ...
            ' p: ' num2str(n_back_1_corr(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared to previous_n_back_4 trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_fischerSD'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        figure(500+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        
        [ b, bint, r, p ] = analysis_func (RO_n_back_5, err);
        
        
        n_back_5_Fit(iParticipant,iCond).b = b;
        n_back_5_Fit(iParticipant,iCond).bint = bint;
        n_back_5_Slope(iParticipant,iCond) = b(1);
        n_back_5_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        n_back_5_corr(iParticipant,iCond).r = r;
        n_back_5_corr(iParticipant,iCond).p = p;
        
        %Now get 
        scatter (RO_n_back_5, err,40,'k','filled');
        axis([-90,90,-90,90]);
        
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(n_back_1_corr(iParticipant,iCond).r) ...
            ' p: ' num2str(n_back_1_corr(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared to previous n-5  trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_fischerSD'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        
        
        
       
    end
    
    [ gain, responseHat, residual] = fitCircularSimpleKalman( stimOri,respOri );
    
    figure (600)
    plot(responseHat)
    
    [ weights, responseHat, residual] = fitCircularStimulusAverage( stimOri,respOri,5 );
    
    figure (700)
    plot(weights)
    
end


        
        
       
        
             
             
             
            
            
            