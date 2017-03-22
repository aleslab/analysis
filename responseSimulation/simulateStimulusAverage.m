function [ response ] = simulateStimulusAverage( stimulus, weights )



for i= 2:length (stimulus);
    
    resposne(i) = stimulus(i)*weights(i)+stimulus(i-1)*weights(i-2)+stimulus*weights(i-3);
    
end


response = resposne (1:end);

end

