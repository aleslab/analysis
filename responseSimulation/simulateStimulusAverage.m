function [ response ] = simStimAve( stimulus, weights, proximalVariance )

%Double the angle, because we have a symmetric stim
stimulus = 2*stimulus;
stimSin = sind(stimulus);
stimCos = cosd(stimulus);

nWeights = length(weights);
nStim    = length(stimulus);

for iTrial = nWeights:nStim,
    
respSin(iTrial) = weights.*simSin((iTrial-nWeight+1):iTrial);
respCos(iTrial) = weights.*simCos((iTrial-nWeight+1):iTrial);
end

response = atan2(respSin,respCos);
respons = response/2;
