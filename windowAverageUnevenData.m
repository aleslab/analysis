function [ yMean, yStdErr, yVar, yN] = windowAverageUnevenData( xOrig,yOrig,xNew,windowSize )
%windowAverageUnevenSampled Applies averaging window to uneven data. 
%[ yMean, yStdErr, yVar, yN] = windowAverageUnevenSampled( xOrig,yOrig,xNew,windowSize )
%
%This function is used to calcluate a windowed average for data that is
%unevenly/randomly sampled. It applies a boxcar window average to calculate
%the mean and also returns the standard error of the mean.
%
%
%
%Inputs:
%
%xOrig - vector of x values
%yOrig - Vector of y values
%xNew  - [nx1 vector] Center of averaging windows to use. 
%windowSize = [scalar] Full width of window for averaging. Goes from xNew -windowSize/2
%             to xNew+windowSize/2 inclusive of the edges
%
%Outputs:
%yMean   - [size(xNew)] Windowed average of yOrig with ce
%yStdErr - [size(xNew)] Standard Error of yMean
%yVar    - [size(xNew)] Variance of data used to calculate yMean
%yN      - [size(xNew)] Number of data samples in averaging window.
%
%Example:
%
% %Generate some noise data
% xOrig = 360*rand(200,1)
% yOrig = sind(xOrig)+randn(size(xOrig))*.2;
% %Setup locations to average and window size
% xNew  = linspace(0,360,20);
% windowSize = 18; %360/20 
% [ yMean yStdErr yVar yN xEdges] = windowAverageUnevenSampled( xOrig,yOrig,xNew,windowSize );
% 
% scatter(xOrig,yOrig)
% hold on;
% errorbar(xNew,yMean,yStdErr,'k','linewidth',2)

if nargin<4
    error('Not enough input arguments')
end

nX = length(xNew);

%Column vectorize input so we know input is column vector. 
xOrig = xOrig(:);
yOrig = yOrig(:);
xNew  = xNew(:);

%initialize outputs. 
nBin = length(xNew);
yMean = nan(size(xNew));
yVar    = yMean;
yStdErr    = yMean;
yN    = yMean;

%Just loop through the bins.  There are more elegent ways but this is
%simpler to think about
for iBin= 1:nBin,

    %For
    binCenter = xNew(iBin);
    binEdgeLo = binCenter - windowSize/2;
    binEdgeHi = binCenter + windowSize/2;
    %This is inclusive of bin edges.  
    selectedSamples = xOrig>=binEdgeLo & xOrig<=binEdgeHi;
    
    samplesInBin  = yOrig(selectedSamples);
    nSamples      = length(samplesInBin);
    
    %Skip if no samples in the bin
    if nSamples == 0
        continue;
    end
    yMean(iBin)   = mean(samplesInBin);
    yVar(iBin)    = var(samplesInBin);
    yStdErr(iBin) = std(samplesInBin)/sqrt(nSamples);
    yN(iBin)      = nSamples;
    
    

end





end

