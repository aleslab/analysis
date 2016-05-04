function output = nodelayKalman(gain,input)
%function output = simpleKalman(X,input);
%
%

nT = length(input);
x = nan(nT,1);
x(1) = input(1);

for iT = 2:nT,
    
% Prediction for state vector and covariance:
   x(iT) = x(iT-1);
   
   % Compute Kalman gain factor:
%    K = s.P*s.H'*inv(s.H*s.P*s.H'+s.R);

   % Correction based on observation:
   x(iT) = x(iT) + gain*(input(iT)-x(iT));
%   s.P = s.P - K*s.H*s.P;

end

output = x;
