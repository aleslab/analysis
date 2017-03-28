function [ response ] = simulateStimulusAverage( stimulus, weights )


% respOri=wrapTo90(respOri);
stimulus=wrapTo90(stimulus);

nweights = length(weights);

for i= nweights:length (stimulus);
    
    response(i) = stimulus(i)*weights(i)+stimulus(i-1)*weights(i-1)+stimulus(i-2)*weights(i-2);
    
end

minAngleDiff(response,90) <=tol;

response  = response (3:end);
weights = weights (3:end);


end

