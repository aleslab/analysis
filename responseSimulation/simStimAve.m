function [ response ] = simStimAve( stimulus, weights, proximalVariance )

weights = fliplr(weights);
%Double the angle, because we have a symmetric stim
stimulus = 2*stimulus;
stimSin = sind(stimulus);
stimCos = cosd(stimulus);

nWeights = length(weights);
nTrial    = length(stimulus);

respSin = stimSin;
respCos = stimCos;

for iTrial = nWeights:nTrial,
    
respSin(iTrial) = sum(weights.*stimSin((iTrial-nWeights+1):iTrial));
respCos(iTrial) = sum(weights.*stimCos((iTrial-nWeights+1):iTrial));
respl(iTrial) = sum(weights.*stimulus((iTrial-nWeights+1):iTrial));

end

response = atan2d(respSin,respCos);

response = response/2;
%response = response(nWeights:end);