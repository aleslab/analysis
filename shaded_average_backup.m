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
[b,~,~,~, whitney_err_unwrap] = circularSlope90d(whitney_err, RO); % corrects here for wrap errors




figure(102+iParticipant); % create a new figure for each partcipant
%clf;
%whitey plot
set(gca,'fontsize', 28);

scatter (RO, whitney_err_unwrap,6); %make a scatter with teh corrected whiteny error data against the RO
hold on
Xline = linspace (-60,60, 10);% plot a basic line
yHat = b*Xline+mean(whitney_err_unwrap);% create a regression line
ROnew  = linspace(-70,70,50);% plot the RO at 50 locations between -70 and 70 degrees on the X axis
[WE_mean, WE_StdErr] = windowAverageUnevenData( RO,whitney_err_unwrap,ROnew,12); % use a funtion to calc 
% an avearge in a window for the size of the window you need here we set to
% 12 so it will give a mean error for each window of 12 degs in our
% data-smooths out the error bascially 
WE_mean(isnan(WE_mean))=0; % if we get a no number then remove it
WE_StdErr(isnan(WE_StdErr)) = 0; % same here 
plot(ROnew, WE_mean) % plot the new ro and smoothed error

createShadedRegion(ROnew,WE_mean,...
    WE_mean-WE_StdErr,WE_mean+WE_StdErr,...
     'linewidth', 4); % create a shaded area that shows teh standard error



plot (Xline, yHat,'LineWidth',8); % plot the slopes we want 
axis([-90,90,-30,30]); % set the axis-will need to be chanegd for random and correlated stim
%line([-90 90], [-90 90],'linewidth', 10);
box off % get rid of teh annoying box
hold on
legend ('Participant error (deg) vs relative orientation(deg)'); % legends etc 
xlabel('Relative orientation of current trial compared to previous trial(deg)');
ylabel('Participant error on current trial (deg)');


    end
    
    for 
    
allPartwhitney_err(:,iCond,iParticipant) = mean(whitney_err_unwrap);
allPartNewRO(:,iCond,iParticipant) = mean(ROnew);




%% 




end