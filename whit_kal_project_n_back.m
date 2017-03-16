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
             RO_n_back_2(i)= minAngleDiff (stimOri(i-2),stimOri (i));
             RO_n_back_3(i) = minAngleDiff (stimOri(i-3), stimOri(i));
             RO_n_back_4(i)= minAngleDiff (stimOri(i-4), stimOri(i));
             
        end
        
        
        err = err(5:end);
        RO  = RO(5:end);
        RO_n_back_2=RO_n_back_2(5:end);
        RO_n_back_3=RO_n_back_3(5:end);
        RO_n_back_4=RO_n_back_4(5:end);
             
             
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
        n_back_1_corr(iParticipant,iCond).r = r(1,2);
        n_back_1_corr(iParticipant,iCond).p = p(1,2);
        %calyculate regression slopes
        myModel = cat(1,RO,ones(size(RO)))';
        myY     = err';
        [b bint] = regress(myY, myModel);
        n_back_1_Fit(iParticipant,iCond).b = b;
        n_back_1_Fit(iParticipant,iCond).bint = bint;
        n_back_1_Slope(iParticipant,iCond) = b(1);
        n_back_1_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
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
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter ( RO_n_back_2, err,40,'k','filled');
        %add a regresion line
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO_n_back_2, err);
        n_back_2_corr(iParticipant,iCond).r = r(1,2);
        n_back_2_corr(iParticipant,iCond).p = p(1,2);
        %calyculate regression slopes
        myModel = cat(1,RO_n_back_2,ones(size(RO_n_back_2)))';
        myY     = err';
        [b bint] = regress(myY, myModel);
        n_back_2_Fit(iParticipant,iCond).b = b;
        n_back_2_Fit(iParticipant,iCond).bint = bint;
        n_back_2_Slope(iParticipant,iCond) = b(1);
        n_back_2_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(n_back_2_corr(iParticipant,iCond).r) ...
            ' p: ' num2str(n_back_2_corr(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared to previous trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_fischerSD'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        
       
        figure(300+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        %whitney plot
        set(gca,'fontsize', 16);
        hold on
        scatter ( RO_n_back_3, err,40,'k','filled');
        %add a regresion line
        
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO_n_back_3, err);
        n_back_3_corr(iParticipant,iCond).r = r(1,2);
        n_back_3_corr(iParticipant,iCond).p = p(1,2);
        %calyculate regression slopes
        myModel = cat(1,RO_n_back_3,ones(size(RO_n_back_3)))';
        myY     = err';
        [b bint] = regress(myY, myModel);
        n_back_3_Fit(iParticipant,iCond).b = b;
        n_back_3_Fit(iParticipant,iCond).bint = bint;
        n_back_3_Slope(iParticipant,iCond) = b(1);
        n_back_3_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        
        %Now get 
        axis([-90,90,-90,90]);
        axis square
        hold on
        title({thisLabel; ...
            [' r: ' num2str(n_back_3_corr(iParticipant,iCond).r) ...
            ' p: ' num2str(n_back_3_corr(iParticipant,iCond).p) ]});
        
        if iCond ==1
        xlabel('Relative orientation of current trial compared to previous trial(deg)');
        ylabel('Error on current trial (deg)');
        end
        thisFilename = [ptbCorgiData.paradigmName ...
            '_' thisParticipantId '_fischerSD'];

        set(gcf,'FileName',thisFilename)
        set(gcf,'position',figurePosition);
        
        
        
       %Linear Regression to fit n-back 
       %Or equation: R = a*S(i) + b*S(i-1)...
       % R = myModel*b + bint
       myModel = cat(1,stimOri(5:end),stimOri(4:end-1), stimOri(3:end-2),...
           stimOri(2:end-3),stimOri(1:end-4),ones(size(RO_n_back_3)))';
       myY     = respOri(5:end)';
       
        [b bint] = regress(myY, myModel);
        n_back_full_fit(iParticipant,iCond).b = b;
        n_back_full_fit(iParticipant,iCond).bint = bint;
        n_back_full_Slope(iParticipant,iCond,:) = b;
        n_back_full_SlopeInt(iParticipant,iCond,:) = bint(1,:);
        
        %Plot slopes
        figure(1000+iParticipant);        
        %put all conditions in 1 plot.
        subplot(1,ptbCorgiData.nConditions,iCond)
        errorbar(0:4,b(1:5),bint(1:5,1)-b(1:5),bint(1:5,2)-b(1:5))
       
        %Analysis looking at stimulus ONLY
        myModel = cat(1,stimOri(4:end-1), stimOri(3:end-2),...
        stimOri(2:end-3),stimOri(1:end-4),ones(size(RO_n_back_3)))';
        myY     = stimOri(5:end)';
       [b bint] = regress(myY, myModel)
        
        
    end
end
        
        
       
        
             
             
             
            
            
            