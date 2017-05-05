function [ gain, responseHat, residual] = fitCircularSimpleKalman( stimulus,response )
%fitCircularStimulusAverage Fits a rolling stimulus average model respecting circular variable.
%   [ gain, responseHat, residual] = fitCircularStimulusAverage( stimulus,response )
%
%   Fits a model:
%   response(t) = response(t-1) + gain*(stimulus(iT) - response(t-1);
%
%  Crucially this function treats all values as circular variables defined
%  on +/- 90 degrees.
%
%  inputs:
%  response: Output response data to fit
%  stimulus: Input signal to use to fit data
%
%  Outputs:
%  weights: Vector containing the fitted weights
%  responseHat: Resulting fit to the response using the weights
%  residual: Circular difference between the response and responseHat

stimulus = stimulus(:);
response = response(:);
gain0 = .5;
gain = fminsearch(@circularCostFunc,gain0,[],stimulus,response);


%weights = weights./sum(weights);
responseHat = circularKalman(gain,stimulus);

residual    = minAngleDiff(response,responseHat);

    function y= circularCostFunc(gain, stim,data)
        
        %Truncate edges.
        %data = data(2:end);
        dataHat = circularKalman(gain, stim);
        
        %Sum of the squared angle difference.
        y = sum( minAngleDiff(data,dataHat).^2);
        
    end

%This is a very specific kalman for random walk. 
    function   dataHat = circularKalman(gain, stim)
        
        %nWeights = length(gain);
        nT = length(stim);
        
        %Multiply by 2 because of gabor symmetry
        stimSin = sind(stim*2);
        stimCos = cosd(stim*2);
        dataHatSin = stimSin;
        dataHatCos = stimCos;
        
        for iT = 2:nT,
             
            %THis if for a simple prediction:
            %Y(n) = Y(n-1) + gain*(stim(n)-y(n-1)) = Y(n-1)-g*Y(n-1) + g*(x(n))
            %     = (1-g)*Y(n-1) + g*x(n); 
            %The simple linear equation is:
            %dataHat(iT) = (1-gain)*dataHat(iT-1) + gain*stim(iT);
            %However because this is circular we need to make sure to
            %combine the values respecting the circular flip.
            %to do this we use trigonometry to separate out into two equations.
            dataHatSin(iT) = (1-gain)*dataHatSin(iT-1) + gain*stimSin(iT);
            dataHatCos(iT) = (1-gain)*dataHatCos(iT-1) + gain*stimCos(iT);
            
            
        end
        
        %Now transform back from sin/cos components to angles. 
        dataHat = atan2d(dataHatSin,dataHatCos);
        
        %Divide by two to go to +/- 90 degrees.
        dataHat = dataHat/2;
       % dataHat = dataHat(2:end);
    end

end
