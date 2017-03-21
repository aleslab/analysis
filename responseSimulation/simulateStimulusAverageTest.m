%% Test 1: simple input
% test that equal weight
tol = 1e-14;
stimulus = [0 30];
weights  = [.5 .5];

response = simulateStimulusAverage(stimulus, weights);

assert( abs(response-15) <=tol);



%% Test 1: simple input
% test that equal weight
tol = 1e-14;
stimulus = [-89 89];
weights  = [.5 .5];

response = simulateStimulusAverage(stimulus, weights);

assert( minAngleDiff(response,90) <=tol);

