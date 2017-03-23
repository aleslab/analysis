function [ response ] = simulateStimulusAverage( stimulus, weights )


respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);

for i= 2:length (stimulus);
    
    response(i) = stimulus(i)*weights(i)+stimulus(i-1)*weights(i-1)+stimulus(i-2)*weights(i-2);
    
end


response  = response (3:end);
weights = weights (3:end);


end

