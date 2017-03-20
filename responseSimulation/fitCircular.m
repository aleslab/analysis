function [ weights ] = fitCircular( stim,data,nweights )
%UNTITLED18 Summary of this function goes here
%   Detailed explanation goes here


weight0 = zeros(nweights,1);
weights = fminsearch(@stimAverage,weight0,[],stim,data);


weights = weights./sum(weights);

function y= stimAverage(weights, stim,data)

    nWeights = length(weights);
    data = data(nWeights:end);
    %Multiply by 2 because of gabor symmetry
    stimSin = sind(stim*2);
    stimCos = cosd(stim*2);
    
    %Create a matrix of shifts.
    stimSin = toeplitz(stimSin);
    stimCos = toeplitz(stimCos);
    
    stimSin = stimSin(nWeights:end,1:nWeights);
    stimCos = stimCos(nWeights:end,1:nWeights);
    
    respSin = stimSin*weights;
    respCos = stimCos*weights;
    
    dataHat = atan2d(respSin,respCos)';

    dataHat = dataHat/2;
    
    y = sum( minAngleDiff(data,dataHat).^2);
    
end

end
