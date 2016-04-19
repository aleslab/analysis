%% Choose and load a data file:
[filename pathname] = uigetfile()
%load data
load(fullfile(pathname,filename))

%%
maxlag=120;
frameDur = sessionInfo.expInfo.frameDur;
t=linspace(-maxlag*frameDur,maxlag*frameDur,maxlag*2+1);
figure(101)
clf
figure(102)
clf
nCond = length(sessionInfo.conditionInfo);
for iCond = 1:nCond,
    
    nReps = sessionInfo.conditionInfo(iCond).nReps
    condList = find([experimentData.condNumber]==iCond);
    contrastList(iCond) = sessionInfo.conditionInfo(iCond).contrast
    
    for iRep = 1:nReps,
        thisTrial = condList(iRep);     
        
        thisResp = experimentData(thisTrial).trialData.respOri;
        thisStim = experimentData(thisTrial).trialData.stimOri;
        
        %0 Mean data because we don't care about the mean orientation
        thisResp = thisResp - mean(thisResp);
        thisStim = thisStim - mean(thisStim);
        %A simple difference is not a great velocity filter but is quick
        %and dirty and works. 
        respVel = diff(thisResp);
        stimVel = diff(thisStim);
        velImpulseResp = xcorr(respVel,stimVel,maxlag,'unbiased');
        posImpulseResp = xcorr(thisResp,thisStim,maxlag,'unbiased');
        stimStim = xcorr(thisStim,thisStim,maxlag,'unbiased');
    end
    
    figure(101)
    plot(t,velImpulseResp);
    hold on
    figure(102)
    plot(t,posImpulseResp-posImpulseResp(120));
    hold on
    
end

figure(101)
xlabel('time in milliseconds')
legend(num2str(contrastList(1)),num2str(contrastList(2)),num2str(contrastList(3)))
figure(102)
xlabel('time in milliseconds')
legend(num2str(contrastList(1)),num2str(contrastList(2)),num2str(contrastList(3)))
