function [ output_args ] = simple2afcplot( analysisOptions, participantData )
%simple2afcplot Just plots 2afc data
%   Detailed explanation goes here

%Pull out the specific data needed. 
[nCorrect nTrials] = build2AfcMatrix(participantData.sessionInfo,participantData.experimentData);
%Split into different condition groups
conditionGroups = groupConditionsByField(participantData.sessionInfo.conditionInfo,...
    analysisOptions.groupingField);

nGroups = length(conditionGroups);

%make a new figure.
figure;
clf;

%Whatfield should we use for the xAxis.
xAxisField = analysisOptions.xAxisField;
%TODO MAKE THIS WORK FOR non
for iGroup = 1:nGroups,
    
    condList = conditionGroups{iGroup};
    xVal = abs([participantData.sessionInfo.conditionInfo(condList).(xAxisField)]);
    thisGroupValue = participantData.sessionInfo.conditionInfo(condList(1)).(analysisOptions.groupingField);
    %  plot(xVal,percentCorrect(iPpt,condList),'o')
    plot2afc(xVal,nCorrect(condList),nTrials(condList));
    hold on;
    
    legendLabels{iGroup} = [analysisOptions.groupingField ' = '...
        num2str(thisGroupValue,3)];
    
    
end

paradigmName = participantData.sessionInfo.expInfo.paradigmName;

title ([ paradigmName ' ' participantData.participantID],'interpreter','none')
xlabel( xAxisField)
ylabel( 'Percent Correct')
legend(legendLabels)

end

