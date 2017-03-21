function [rho pval] = circ_corrccd(alpha1, alpha2)
%
% [rho pval ts] = circ_corrcc(alpha1, alpha2)
%   Circular correlation coefficient for two circular random variables.
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
% PHB 6/7/2008
%
% Circular Statistics Toolbox for Matlab

% 
% By Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html
%

alpha1 = deg2rad(alpha1);
alpha2 = deg2rad(alpha2);

[rho pval] = circ_corrcc(alpha1,alpha2);


end

