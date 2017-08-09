nT = 100;
nX = 100;

stimMat = zeros(nX,nT);
stimStart = 0;
pixVel = 0.5;
pixVel2 = 1;
barWidth = 4;
gapStart = 50;
gapDuration = 20;

for iT = 1:gapStart-1
    
    stimLocation = round(stimStart + iT*pixVel);
    stimMat(stimLocation: stimLocation+barWidth, iT) = 1;
    
end

for iT = gapStart:gapStart+gapDuration
    
   
    
end

for iT = gapStart+gapDuration+1: nT
    
  stimLocation = round(stimLocation + pixVel2);
    stimMat(stimLocation: stimLocation+barWidth, iT) = 1;  
    
end
figure(101)
imagesc(stimMat);

figure(102)
fourierMat = fft2(stimMat);
imagesc(fftshift(abs(fourierMat)));
