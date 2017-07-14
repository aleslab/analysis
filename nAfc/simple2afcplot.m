function [ ] = simple2afcplot( analysisOptions, participantData )
%simple2afcplot Just plots 2afc data
%   Detailed explanation goes here(Function still WiP)

ptbCorgiSetPlotOptions();
%Pull out the specific data needed. 
[nCorrect nTrials] = build2AfcResponseMatrix(participantData.sessionInfo,participantData.experimentData);
%Split into different condition groups
conditionGroups = groupConditionsByField(participantData.sessionInfo.conditionInfo,...
    analysisOptions.groupingField);

nGroups = length(conditionGroups);

%make a new figure.
figHandle = figure;
clf;
ptbCorgiSetPlotOptions(figHandle);

%Whatfield should we use for the xAxis.
xAxisField = analysisOptions.xAxisField;
%TODO MAKE THIS WORK FOR non ordered conditions. 
for iGroup = 1:nGroups,
    
    condList = conditionGroups{iGroup};
    xVal = abs([participantData.sessionInfo.conditionInfo(condList).(xAxisField)]);
    thisGroupValue = participantData.sessionInfo.conditionInfo(condList(1)).(analysisOptions.groupingField);
    %  plot(xVal,percentCorrect(iPpt,condList),'o')
    set(gca,'ColorOrderIndex',iGroup)
    plotHandle(iGroup) = plot2afc(xVal,nCorrect(condList),nTrials(condList));
    hold on;

    legendLabels{iGroup} = [analysisOptions.groupingField ' = '...
        num2str(thisGroupValue,3)];
    
    if isfield( participantData.analysisResults,'functionFitX')
        xValues = participantData.analysisResults.functionFitX{iGroup};
        yValues = participantData.analysisResults.functionFitY{iGroup};
        yLo = participantData.analysisResults.functionFitBootLo{iGroup};
        yHi = participantData.analysisResults.functionFitBootHi{iGroup};
        
        createShadedRegion(xValues,yValues,yLo, yHi,':','color',get(plotHandle(iGroup),'color'));
    end
    
end

paradigmName = participantData.sessionInfo.expInfo.paradigmName;

title ([ paradigmName ' ' participantData.participantID],'interpreter','none')

if isfield(analysisOptions,'xLabel')
    xlabel(analysisOptions.xLabel);
else
    xlabel( xAxisField);
end

ylabel( 'Proportion "Faster" responses')
legend(plotHandle,legendLabels,'location','best')

end

