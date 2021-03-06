function [rho pval] = circ_corrccd90(alpha1, alpha2)
%
% [rho pval ts] = circ_corrccd90(alpha1, alpha2)
%   Circular correlation coefficient for two circular random variables that
%   wrap around [-90, 90] degrees.  This is useful for situations in which
%   there is symmetry (i.e. A 180 degree rotation is the same. 
%   
%   Input:
%     alpha1	sample of angles in degrees
%     alpha2	sample of angles in degrees
%
%   Output:
%     rho     correlation coefficient
%     pval    p-value
%
% References:
%   Topics in circular statistics, S.R. Jammalamadaka et al., p. 176
%
%

% JMA 03/2017
% Wrapper for circ_corrcc from the CircStat toolbox written by
% Justin Ales
%
% Circular Statistics Toolbox for Matlab
% 
% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html
%

alpha1 = deg2rad(2*alpha1);
alpha2 = deg2rad(2*alpha2);

[rhoScal pvalScal] = circ_corrcc(alpha1,alpha2);

rho(1,1) = 1;
rho(1,2) = rhoScal;
rho(2,1) = rhoScal;
rho(1,1) = 1;

pval(1,1) = 1; 
pval(2,2) = 1;
pval(2,1) = pvalScal;
pval(1,2) = pvalScal;



end

