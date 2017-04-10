function [ output_args ] = plot2afc( x, nCorrect, nTrials )
%plot2afc plots 2afc data with 95% confidence intervals
%   Detailed explanation goes here

percentCorrect = nCorrect./nTrials;
lowerCi = percentCorrect - binoinv(.025,nTrials,percentCorrect)./nTrials;
upperCi = binoinv(.975,nTrials,percentCorrect)./nTrials - percentCorrect;

errorbar(x,percentCorrect,lowerCi,upperCi);
  

end

