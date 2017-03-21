function [ b bint ] = circularRegress( Y,X )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% B = regress(Y,X)

weight0 = ones(size(X,2),1);

[weights, RESNORM,resid,EXITFLAG,OUTPUT,LAMBDA,J] = lsqnonlin(@circularFit,weight0,[],[],[],Y,X);
b = weights;

if nargout >=2
    alpha = 0.05;
    n = length(resid);
    p = numel(b);
    v = n-p;
    % Calculate covariance matrix
    [~,R] = qr(J,0);
    Rinv = R\eye(size(R));
    diag_info = sum(Rinv.*Rinv,2);
    
    rmse = norm(resid) / sqrt(v);
    se = sqrt(diag_info) * rmse;
    
    % Calculate confidence interval
    delta = se * tinv(1-alpha/2,v);
    bint = [(b(:) - delta) (b(:) + delta)];
end

function error = circularFit(weights, Y,X)

yHat = X*weights;

error = minAngleDiff(Y,yHat);