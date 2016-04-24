
nT = 400;
%input = cumsum(randn(nT+1,1));
% gain = 1;
% delay = 10;
% 
% 
% x(1) = input(1);
% 
% 
% for iT = 2:nT,
%     
% % Prediction for state vector and covariance:
%    x(iT) = x(iT-1);
%    
%    % Compute Kalman gain factor:
% %    K = s.P*s.H'*inv(s.H*s.P*s.H'+s.R);
% 
%    % Correction based on observation:
%    x(iT) = x(iT) + gain*(input(iT)-x(iT));
% %   s.P = s.P - K*s.H*s.P;
% 
% end
% 
% x = [x(1)*ones(delay,1); x(1:end-delay)]

xSim = simpleKalman([.3 4.1],input);

myObj = @(x)(simpleKalman(x,input)-xSim)
x0= [.5 2]
fitParam = lsqnonlin(myObj,x0)

xFit = simpleKalman(fitParam,input);
figure(42)
clf
plot(input)
hold on
plot(xSim)
plot(xFit);


%%
fitData = struct();

for i=1:3,
fitData(i).gain = [];
fitData(i).delay = [];
fitData(i).resnorm = [];
end

idx =1;
for iTrial = 1:length(experimentData),
input = (experimentData(iTrial).trialData.stimOri)';
response = (experimentData(iTrial).trialData.respOri)';


myObj = @(param)(simpleKalman(param,input)-response);
x0= [.5 2];
[fitParam,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = ...
    lsqnonlin(myObj,x0);

thisCond = experimentData(iTrial).condNumber;
fitData(thisCond).gain(end+1) = fitParam(1);
fitData(thisCond).delay(end+1) = fitParam(2);

fitData(thisCond).resnorm(end+1) = RESNORM;
% xFit = simpleKalman(fitParam,input);
% figure(42)
% clf
% plot(input)
% hold on
% plot(response)
% plot(xFit);
% 
% pause;
end


%%
nCond = length(sessionInfo.conditionInfo);
for iCond = 1:nCond,
contrastList(iCond) = sessionInfo.conditionInfo(iCond).contrast;

goodFits = 1:20;find(fitData(2).resnorm< 1e7);
nT = length([fitData(iCond).gain(goodFits)]);
gainMean(iCond) = mean([fitData(iCond).gain(goodFits)]);
gainSEM(iCond)  = std([fitData(iCond).gain(goodFits)])./sqrt(nT);

delayMean(iCond) = mean([fitData(iCond).delay(goodFits)]);
delaySEM(iCond)  = std([fitData(iCond).delay(goodFits)])./sqrt(nT);

end


subplot(1,2,1)
errorbar(contrastList, gainMean,gainSEM,'o')
title('Kalman Gain')
subplot(1,2,2)
errorbar(contrastList, delayMean,delaySEM,'o')
title('Delay')




