function [ response ] = simStimAve( stimulus, weights, proximalVariance )

<<<<<<< HEAD
stimulus = [0 30 60];

weights = [0.5 0.5];
=======
%Double the angle, because we have a symmetric stim
stimulus = 2*stimulus;
stimSin = sind(stimulus);
stimCos = cosd(stimulus);
>>>>>>> origin/master

nWeights = length(weights);
nStim    = length(stimulus);

for iTrial = nWeights:nStim,
    
respSin(iTrial) = weights.*simSin((iTrial-nWeight+1):iTrial);
respCos(iTrial) = weights.*simCos((iTrial-nWeight+1):iTrial);
end

response = atan2(respSin,respCos);
respons = response/2;
