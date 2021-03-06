% fileList = {'/path/to/data1.mat',  '/path/to/data2.mat' };
% %**BEGIN Code autogenerated by ptbCorgiDataBrowser() BEGIN***
%  filesToLoad = { ...
%  '/Users/fa28/markov_test/markov_test_1__20180620_114458.mat';...
%  '/Users/fa28/markov_test/markov_test_1__20180620_120048.mat';...
%  '/Users/fa28/markov_test/markov_test_1__20180620_121720.mat';...
%  '/Users/fa28/markov_test/markov_test_1__20180620_123428.mat';...
% };
% ptbCorgiData = overloadOpenPtbCorgiData( filesToLoad );
% %***END Code autogenerated by ptbCorgiDataBrowser() END***


ptbCorgiData = uiGetPtbCorgiData();


[valid_trials] = buildMatrixFromField('validTrial',ptbCorgiData);

[stimStartTime] = buildMatrixFromField('stimStartTime', ptbCorgiData);

[RTBoxGetSecsTime] = buildMatrixFromField('RTBoxGetSecsTime',ptbCorgiData);

%[RTBoxEvent] = buildMatrixFromField('RTBoxEvent',ptbCorgiData);

reaction_times = RTBoxGetSecsTime(1,:,:) - stimStartTime; 
