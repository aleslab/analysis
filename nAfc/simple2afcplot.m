function [ ] = simple2afcplot( analysisOptions, participantData )
%simple2afcplot Just plots 2afc data
%   Detailed explanation goes here(Function still WiP)

ptbCorgiSetPlotOptions();



%Pull out the specific data needed. 
if ~isfield( analysisOptions,'yAxisField')
    warning('ptbCorgi:2afcplot:noYaxisSpecified','No y-axis field specificed, attempting to guess');
    
    if isfield(participantData.sortedTrialData(1).experimentData,'isResponseCorrect')
       
        analysisOptions.yAxisField = 'isResponseCorrect';
        %[nCorrect nTrials] = build2AfcMatrix(participantData.sessionInfo,participantData.experimentData);
    elseif isfield(participantData.sortedTrialData(1).experimentData,'response')
        analysisOptions.yAxisField = 'response';
        %[nCorrect nTrials] = build2AfcResponseMatrix(participantData.sessionInfo,participantData.experimentData);
    end
end    
    
dataMatrix  =  buildMatrixFromField(analysisOptions.yAxisField,participantData.sessionInfo,participantData.experimentData);

if ~isfield(analysisOptions,'yAxisCorrectVal')
    
    %Find the values in the data that are not NaN;
    uniqueVal = unique(dataMatrix( ~isnan(dataMatrix(:))));  
    if length(uniqueVal)>2
        error('Data contains more than 2 possible values. Not appropriate for this function');
    end
    analysisOptions.yAxisCorrectVal = uniqueVal(2);
end

%Now calculate the number "correct" and total number of trials. 
dataIsCorrect = (dataMatrix == analysisOptions.yAxisCorrectVal);
nCorrect = squeeze(nansum(dataIsCorrect,2));
nTrials = squeeze(sum(~isnan(dataMatrix),2));

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
 
for iGroup = 1:nGroups,
    
    condList = conditionGroups{iGroup};
    xVal = ([participantData.sessionInfo.conditionInfo(condList).(xAxisField)]);
    thisGroupValue = participantData.sessionInfo.conditionInfo(condList(1)).(analysisOptions.groupingField);
    
    %Now here's a tricky one. We don't know what xVal has. Maybe 0 to 10, or
    %say -10 to 0, or maybe -10 to 10. We're going to treat -10 to 0 as if
    %it was 0 -> +10.
    %
    if any(sign(xVal)==1) && any(sign(xVal)==-1) ; %Checkes if there are both postive and negative
        StimLevels = xVal;
    else
        StimLevels = abs(xVal);
    end
    %Sort stim levels. 
    [StimLevels, sortIdx] = sort(StimLevels);
        
    
    %  plot(xVal,percentCorrect(iPpt,condList),'o')
    set(gca,'ColorOrderIndex',iGroup)
    %set(gca,'fontweight', 'bold','fontsize', 36,'ColorOrderIndex');
    plotHandle(iGroup) = plot2afc(StimLevels,nCorrect(condList(sortIdx)),nTrials(condList(sortIdx)));
    hold on;

    legendLabels{iGroup} = [analysisOptions.groupingField ' = '...
        num2str(thisGroupValue,3)];
    

    if isfield( participantData.analysisResults,'functionFitX')
        xValues = participantData.analysisResults.functionFitX{iGroup};
        yValues = participantData.analysisResults.functionFitY{iGroup};
        
        if isfield( participantData.analysisResults, 'functionFitBootLo')
            yLo = participantData.analysisResults.functionFitBootLo{iGroup};
            yHi = participantData.analysisResults.functionFitBootHi{iGroup};
        else 
            yLo = yValues-yValues*1e-6; %Need to add/subtract a little form these values
            yHi = yValues+yValues*1e-6; %because code does convex hull if these values are equal. 
        end
        
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

if isfield(analysisOptions,'yLabel')
    ylabel(analysisOptions.yLabel);
else
    if ischar(analysisOptions.yAxisCorrectVal)
        val = analysisOptions.yAxisCorrectVal;
    elseif isnumeric(analysisOptions.yAxisCorrectVal);
        val = num2str(analysisOptions.yAxisCorrectVal);
    end       
    ylabel([analysisOptions.yAxisField '==' val] );
end

legend(plotHandle,legendLabels,'location','best')

end

