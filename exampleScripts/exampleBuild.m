
%This code was autogenerated on my laptop for loading a few files:
% %***BEGIN Code autogenerated by ptbCorgiDataBrowser() BEGIN***
% filesToLoad = { ...
% '/Volumes/Lee_MIDspeed/Experiment_4/Piloting/AL/zero/lateralLine_gap_AL_pilot_20170616_133731.mat';...
% '/Volumes/Lee_MIDspeed/Experiment_4/Piloting/AL/zero/lateralLine_gap_AL_pilot_20170616_135146.mat';...
% '/Volumes/Lee_MIDspeed/Experiment_4/Piloting/AL/zero/lateralLine_gap_AL_pilot_20170616_141617.mat';...
% };
% ptbCorgiData = overloadOpenPtbCorgiData( filesToLoad );
% %***END Code autogenerated by ptbCorgiDataBrowser() END***

%This code uses the data browser for selecting the data:
ptbCorgiData = uiGetPtbCorgiData();
linePos   = buildMatrixFromField('LinePos',ptbCorgiData);
flipTimes = buildMatrixFromField('flipTimes',ptbCorgiData);

%Bsxfun is an extremely useful matlab function, in r2016b and later it
%actually get's automatically called for basic arithmetic ops* / + -
%Subtract the first frame time so flip times represent trial time instead
%of global time
flipTimes = bsxfun(@minus,flipTimes,flipTimes(:,:,:,1));

figure(101);clf;
%Plot line positions for all trials for condition 1
%Squeeze makes it a 2d matrix, transpose makes the x-axis correct
plot( squeeze(flipTimes(1,1,:,:))',squeeze(linePos(1,1,:,:))' );

figure(102);clf;
%Plot line positions for all participants, all conditions and all trials

%Here's a tricky matlab sequence:

%Make the plotting data the first dimension:
ftPerm = shiftdim(flipTimes,3);
lpPerm = shiftdim(linePos,3);

%Use a funny implicit grouping to collapse 4d matrix into 2d matrix:
plot(ftPerm(:,:),lpPerm(:,:));

