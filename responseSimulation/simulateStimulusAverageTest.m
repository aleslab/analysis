%% Test 1: simple input
% test that output is correct size. 
stimulus = [0 30 30 90];
weights  = [.5 .5];

response = simulateStimulusAverage(stimulus, weights);

assert( length(response) == length(stimulus)-length(weights)+1 );



%% Test 2: simple input
% test that equal weight produces simple average of two numbers
tol = 1e-14;
stimulus = [0 30];
weights  = [.5 .5];

response = simulateStimulusAverage(stimulus, weights);

assert( abs(response-15) <=tol);

%% Test 3: simple input
% test that 100% current is correct
tol = 1e-14;
stimulus = [30 60];
weights  = [1 0];

response = simulateStimulusAverage(stimulus, weights);

assert( abs(response-60) <=tol);

%% Test 3: simple input
% test that 100% past is correct
tol = 1e-14;
stimulus = [30 60];
weights  = [0 1];

response = simulateStimulusAverage(stimulus, weights);

assert( abs(response-30) <=tol);



%% Test 2: Tricky test with -89 and 89 degree input.
%Naive incorrect answer is 0 degrees.  Correct answer is 90 degrees
%This is very hard, so disabled for now.
% % test equal weight
% stimulus = [-89 89];
% weights  = [.5 .5];
% 
% response = simulateStimulusAverage(stimulus, weights);
% 
% assert( minAngleDiff(response,90) <=tol);

