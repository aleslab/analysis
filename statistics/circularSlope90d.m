function [ b, bint, r, p] = circularSlope90d( Y,X )
%circularSlope90d calculate slopes and correlation coefficent (for FA)
%[ b, bint, r, p] = circularSlope90d( Y,X )
%
% This code fits a line to circular data.  It does this by first doing a
% nonlinear least squares fit using a cost function that respects the 
% circular nature of orientation of a symmetric gabor (wraps at +/-90): 
% Objective: sum(minAngleDiff(Y,yHat).^2), yHat = b*X;
% 
%
% Having found a this minimum the code next unwraps Y around the linear
% fit. This removes any jumps around +/-90 and allows the use of standard
% linear methods.  The final values are found using:
% [b bint] = regress()
% [r p]    = corr() 
%  
%Input:
%
%   Y = response (degrees) constrained to +/- 90 degrees
%   X = stimulus values (degrees) constrained to +/- 90 degrees.
%
%Output:
% 
%   b  = Fitted slope
%bint  = confidence interval for slope
%   r  = correlation coefficient
%   p  = p-value for correlation coefficient
% B = regress(Y,X)
options = optimset(@lsqnonlin);
options = optimset(options,'Display','off');


%This code here is kept for posterity.  To remind of a false start.  I
%first defaulted to using the circular mean.  Because it's a circular
%variable.  But that's not what we want here.  We should be treating Y as a
%linear variable, it's just the cost function that should treat it as
%circular.
%First find the circular mean using the circ statistics toolbox
%Multiply by 2 and divide by 2 because we're using +/-90 instead of 180.
%also convert between degrees and radians.
%meanAngle = rad2deg(circ_mean( deg2rad(2*Y) )/2);
%Y = wrapTo90(Y-meanAngle);

%Subtract out the meanAngle 
meanAngle = mean(Y);
Y = Y-meanAngle;
%Do a multistart seach, angles make fitting even a simple slope difficult
%constrainsed to -2, 2. Because for our experiment only the interval 0-1 is
%interesting and this makes sure we've covered it. 
slopeGrid = [-2:.2:2];
nStarts = length(slopeGrid);


for iStart = 1:nStarts,

slope0 = slopeGrid(iStart) ;
[params(iStart), resnorm(iStart)] = lsqnonlin(@circularFit,slope0,[],[],options,Y,X);


%[slope(1), resnorm(1)] = lsqnonlin(@circularFit,slope0,[],[],options,Y,X);

%[weights,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,H] = fmincon(@fminConCircularFit,weight0,[],[],[],[],[],[],[],options,Y,X);
end

% slope0 = sign(-slope(1))* min(abs(1/slope(1)),100);
% [slope(2), resnorm(2)] = lsqnonlin(@circularFit,slope0,[],[],options,Y,X);

%Choose the best solution from the multistart search
[~, bestSol] = min(resnorm);


b = params(bestSol);
%Now generate a linear prediction that isn't wrapped
%i.e. yHat is not wrapped and can take arbitrary angles.
yHat = b*X;

%Linearize Y by adding the fit residual to the linearized Y
%This unwraps Y so Y goes outside the angle constraints but this is still
%valid angles, it's just not constrained.  
%Assuming the slope found above is good, unwrapping makes it so we can use
%linear estimation methods next.
Yangle = Y;
Y = minAngleDiff(Y,yHat)+yHat;

%The unwrap might result in a non-zero mean.  We don't care about this mean
%angle.  
Y = Y-mean(Y);
%Now with linear Y, lets find the slopes and correlation coefficient.

%Correlation coefficient
[r, p] = corr(X,Y);

bCircular = b;
%linear regression to find slope. This should be within the lsqnonlin the
%slope we found with lsqnonlin using the circular cost function.
[b, bint] = regress(Y,X);

tol = 1e-2; %Let's use a fairly loose tolerance to see if we have a difference 
if abs(b-bCircular)>tol
    warning(['WARNING: final linear slope differs from circular fit. Linear: ' ...
        num2str(b) ' Circular: ' num2str(bCircular)]);
end

end

function error = circularFit(weights, Y,X)

%sinX = [sind(X); cosd(X)];
% Y = [sind(Y); cosd(Y)];

%yHat = atan2d(sind(X)*weights,cosd(X)*weights);
yHat = X*weights;

error = minAngleDiff(Y,yHat);
%error = acosd(cosd(2*(Y-yHat)))/2;
end

function error = lsqnonLinCostFunc(weights,Y,X)

%sinX = [sind(X); cosd(X)];
% Y = [sind(Y); cosd(Y)];

%yHat = circularFit(weights,X);
yHat = X*weights;
error = minAngleDiff(Y,yHat);
end

function error = fminConCircularFit(weights,Y,X)

error = sum(lsqnonLinCostFunc(weights,Y,X).^2);
end