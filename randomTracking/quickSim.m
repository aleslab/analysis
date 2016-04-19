
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



