
%load data
ptbCorgiData = uiGetPtbCorgiData();

%Let's fit the data in a special way.
%constraining the function to be 0.5 at 0
%Jointly fitting a lapse rate to both conditions
%Just allowing the slope/variance of the underlying normal to change
%between contrast groups.
analysis.function = @psychometricFitForStep;

%Choose how to group conditions
analysis.funcOptions.groupingField = 'contrast';
%choose what to put on the x-axis. 
analysis.funcOptions.xAxisField = 'targetDelta';

analysis.funcOptions.PF = @PAL_VonMises90d;
[analysis, ptbCorgiData] = ptbCorgiAnalyzeEachParticipant(analysis,ptbCorgiData);

%This function creates a simple 2afc errorbar plot
analysis.function = @simple2afcplot;
%Choose how to group conditions
analysis.funcOptions.groupingField = 'contrast';
%choose what to put on the x-axis. 
analysis.funcOptions.xAxisField = 'targetDelta';
analysis.funcOptions.xLabel     = 'Orientation difference (degrees)';

[analysis, ptbCorgiData] = ptbCorgiAnalyzeEachParticipant(analysis,ptbCorgiData);

%Now let's report the resulting standard deviations.
disp('Ugly, Quick, output of standard deviations:')
nPpt = length( ptbCorgiData.participantList);
for iPpt = 1:nPpt
    
    disp(ptbCorgiData.participantList{iPpt})
    for iContrast = 1:length(analysis.results(iPpt).conditionLabels)
    disp([analysis.results(iPpt).conditionLabels{iContrast} ' k: ' num2str(analysis.results(iPpt).paramsValues(iContrast,2)) ...
        ' Std dev: ' num2str( sqrt(1./analysis.results(iPpt).paramsValues(iContrast,2)))])
    end
end

