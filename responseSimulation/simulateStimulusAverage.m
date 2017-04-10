function [ response ] = simulateStimulusAverage( stimOri, weights )


response (1) = (0);
%stimOri (1) = 0;

for iStim= 2:length (stimOri)
    mySum = 0;
    
    for iWeight = 1:length(weights);
    
    mySum =mySum + stimOri(iStim - iWeight +1) * weights(iWeight);
    
    end
   
    response(iStim) = mySum;
end     


response = response( length(weights):end)
