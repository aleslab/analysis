
%load data
%ptbCorgiData = uiGetPtbCorgiData();



analysis.ptbCorgiData = ptbCorgiData;

%This function creates a simple 2afc errorbar plot
analysis.function = @simple2afcplot;
%Choose how to group conditions
analysis.funcOptions.groupingField = 'contrast';
%choose what to put on the x-axis. 
analysis.funcOptions.xAxisField = 'targetDelta';


ptbCorgiAnalyzeEachParticipant(analysis)