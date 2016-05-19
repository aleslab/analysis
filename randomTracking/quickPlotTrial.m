%%  
iCond = 2;
iTrial = 1;

input = (sortedTrialData(iCond).trialData(iTrial).stimOri)';
response = (sortedTrialData(iCond).trialData(iTrial).respOri)';

 modelFit = simpleKalman([gainMean(iCond) delay],input);
 
 nFrames = length(input);
 t = linspace(0,(nFrames-1)*timePerFrame,nFrames)/1000; %Puts the xaxis in milliseconds
 
 figure(222)
 clf
 plot(t,input,'k');
 hold on
 plot(t,response,'r');
 plot(t,modelFit,'b');
 ylabel('Orientation (degrees)')
 xlabel('Time (Sec)')
 
 figure(333)
 clf
 allTrials= [sortedTrialData(1).trialData(:).respOri];
 %plot(t,allTrials)
 hold on
 plot(t,input,'k','linewidth',5)
 ylabel('Orientation (degrees)')
 xlabel('Time (Sec)')
 