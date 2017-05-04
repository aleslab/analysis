function [ weights, responseHat, residual] = fitCircularStimulusAverage( stimulus,response,nweights )
%fitCircularStimulusAverage Fits a rolling stimulus average model respecting circular variable.
%   [ weights, responseHat, residual] = fitCircularStimulusAverage( stimulus,response,nweights )
%
%   Fits a model:
%   response(t) = weights(1)*stimulus(t) + weights(2)*stimulus(t-1) + ...
%                   + weights(nweights)*stimulus(t-nweights-1)
%
%  Crucially this function treats all values as circular variables defined
%  on +/- 90 degrees.
%
%  inputs:
%  response: Output response data to fit
%  stimulus: Input signal to use to fit data
%  nweights: number of past values to use to fit data.
%
%  Outputs:
%  weights: Vector containing the fitted weights
%  responseHat: Resulting fit to the response using the weights
%  residual: Circular difference between the response and responseHat

weight0 = zeros(nweights,1);
weights = fminsearch(@circularCostFunc,weight0,[],stimulus,response);


weights = weights./sum(weights);
responseHat = circularStimAverage(weights,stimulus);
residual    = minAngleDiff(response,responseHat);

    function y= circularCostFunc(weights, stim,data)
        
        %Truncate edges.
        data = data(nWeights:end);
        dataHat = circularStimAverage(weights, stim)
        
        %Sum of the squared angle difference.
        y = sum( minAngleDiff(data,dataHat).^2);
        
    end

    function   dataHat = circularStimAverage(weights, stim)
        
        nWeights = length(weights);
        
        %Multiply by 2 because of gabor symmetry
        stimSin = sind(stim*2);
        stimCos = cosd(stim*2);
        
        %Create a matrix of shifts.
        stimSin = toeplitz(stimSin);
        stimCos = toeplitz(stimCos);
        
        stimSin = stimSin(nWeights:end,1:nWeights);
        stimCos = stimCos(nWeights:end,1:nWeights);
        
        respSin = stimSin*weights;
        respCos = stimCos*weights;
        
        dataHat = atan2d(respSin,respCos)';
        
        dataHat = dataHat/2;
    end

end
