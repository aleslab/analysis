%% Quick Fit
pf = @PAL_CumulativeNormal;
options = PAL_minimize('options');

stimLevels =100*[0, 0.22, 0.4, 0.55, 0.67, 0.77, 0.86];%linspace(10,90,7);
stimLevels = speedDiff;
%NumPos =  [13 25 29 30 30 30 30];
NumPos = [15 16 17 21 30 27 29]
outOfNum = [30 30 30 30 30 30 30];
% searchGrid.alpha = [0:1:90];    %structure defining grid to
% searchGrid.beta = linspace(0,2,40); %search for initial values
% searchGrid.gamma = .5;
% searchGrid.lambda = 0;
% % 
searchGrid.alpha = linspace(0,90,101);
searchGrid.beta = linspace(0,2,101);
searchGrid.gamma = 0.5;  %scalar here (since fixed) but may be vector
searchGrid.lambda = 0;  %ditto
            
[paramsValues LL exitflag output]  = PAL_PFML_Fit(stimLevels, NumPos, outOfNum, ...
      searchGrid, [1 1 0 0], pf,'searchOptions',options);
  
  
 %paramsValues = PAL_PFML_BruteForceFit(StimLevels, NumPos, OutOfNum, searchGrid, @PAL_CumulativeNormal,'gammaEQlambda',false); 
% [paramsFreeVals, negLL, exitflag, output] = PAL_minimize(@PAL_PFML_negLL, paramsFreeVals, options, paramsFixedVals, paramsFree, StimLevels, NumPos, OutOfNum, PF,'lapseLimits',lapseLimits,'guessLimits',guessLimits,'lapseFit',lapseFit,'gammaEQlambda',gammaEQlambda);

 figure(142);clf
 plot(stimLevels,NumPos./outOfNum,'x')
 hold on;
 plot(0:1:100,PAL_CumulativeNormal(paramsValues,0:1:100))

%% Quick Bootstrap
 [SD paramsSim LLSim converged] = ...
     PAL_PFML_BootstrapNonParametric(stimLevels,NumPos,outOfNum,paramsValues,[1 1 0 0],300,@PAL_CumulativeNormal,...
     'searchGrid',searchGrid);
 
 100*sum(converged)/length(converged)

 
 %% Simulation to test how many trials are needed for bootstrap convergence
clear all;

%Simulate an experiment with these numbers of trials
trialNums = [10 15 30 60 120];
params = [19.3 .08 .5 0.0]; %Fit for the low threshold data

% These are the stim levels you used.
%stimLevels = 100*[0, 0.22, 0.4, 0.55, 0.67, 0.77, 0.86];

% Uncomment this line to try a different choice of conditions
stimLevels = 30*[0, 0.22, 0.4, 0.55, 0.67, 0.77, 0.86];

for iTrialNum = 1:length(trialNums),
    nBoot = 500;
    nStimLevels = 7;
    nTrials     = trialNums(iTrialNum);
    
    %stimLevels = linspace(10,90,nStimLevels);

    pf = @PAL_CumulativeNormal;
    outOfNum = ones(1,nStimLevels)*nTrials;
    
    searchGrid.alpha = [0:2:100];    %structure defining grid to
    searchGrid.beta = linspace(0,2,40); %search for initial values
    searchGrid.gamma = .5;
    searchGrid.lambda = 0;
    
    %PAL_PF_SimulateObserverParametric(params, stimLevels, outOfNum, pf)
    
    [SD paramsSim LLSim converged] = ...
        PAL_PFML_BootstrapParametric(stimLevels,outOfNum,params,[1 1 0 0],nBoot,pf,...
        'searchGrid',searchGrid);
    
    %Percent of bootstraps that fail to converge.
    percentConverged(iTrialNum) = 100*sum(converged)/length(converged);
    %95 confidence interval:

    %From the bootstrap take all the bootstrap sampled paramaters
    %Sort them, then interpolate the data up to 1000 data points to make it
    %easy to grab the 2.5% and 97.5% points for the 95% CI
    alphaInterp = interp1( sort(paramsSim(:,1)),linspace(1,nBoot,1000));
    
    %Here is the CI for alpha
    alphaCI(iTrialNum,:) = [alphaInterp(25) alphaInterp(975)];
    
    betaInterp = interp1( sort(paramsSim(:,2)),linspace(1,nBoot,1000));
    
    betaCI(iTrialNum,:) = [betaInterp(25) betaInterp(975)];

end

 figure(242);clf
 plot(stimLevels,PAL_CumulativeNormal(params,stimLevels),'x')
 hold on;
 plot(0:1:100,PAL_CumulativeNormal(params,0:1:100))
 legend('Condition Locations')
 
figure(342);clf;
plot(trialNums,percentConverged,'+','markersize',10,'linewidth',3)
xlabel('Number of Trials Per Condition')
ylabel('Percent Bootstrap simulations that converge')

figure(442);clf;
subplot(2,1,1)
plot(trialNums,alphaCI,'-o')
ylabel('Alpha')
title('Confidence Ineterval bounds by number of trials');
subplot(2,1,2)
plot(trialNums,betaCI,'-o')
xlabel('Number of Trials Per Condition')
ylabel('beta')



for iBoot = 1:nBoot,
    
    myThreshSim(iBoot) = inverse,75 (paramSim(iBoot,:))


