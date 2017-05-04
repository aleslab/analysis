function [results ] = psychometricFit( analysisOptions, participantData )
%WARNING, this is experimental. 

%Pull out the specific data needed. 
[nCorrect, nTrials] = build2AfcMatrix(participantData.sessionInfo,participantData.experimentData);

%Split into different condition groups
conditionGroups = groupConditionsByField(participantData.sessionInfo.conditionInfo,...
    analysisOptions.groupingField);

nGroups = length(conditionGroups);


%Whatfield should we use for the xAxis.
xAxisField = analysisOptions.xAxisField;


%Fit data for each condition grouping:

for iGroup = 1:nGroups,
    
    condList = conditionGroups{iGroup};
    xVal = ([participantData.sessionInfo.conditionInfo(condList).(xAxisField)]);        
    thisGroupValue = participantData.sessionInfo.conditionInfo(condList(1)).(analysisOptions.groupingField);
    %  plot(xVal,percentCorrect(iPpt,condList),'o')

    conditionLabels{iGroup} = [analysisOptions.groupingField ' = '...
        num2str(thisGroupValue,3)];
    
    %Now setup parameters for palamedes fits.  This is using variable to
    %stay consistent with names in example code from Palamedes for ease of
    %reading. 
    options = PAL_minimize('options'); %options structure containing default    
    %This sets the guess rate fixed and lets the offset/slope/lapse rate vary. 
    paramsFree = [1 1 0 1];
    PF = @PAL_CumulativeNormal;    
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
        
    NumPos   = nCorrect(condList(sortIdx));
    OutOfNum = nTrials(condList(sortIdx));
    
    %If options for the search aren't specified lets make one up with some
    %heuristics. 
    if ~isfield(analysisOptions,'searchGrid') || isempty(analysisOptions.searchGrid)
        %alpha is the offset parameter so lets use a search space that goes
        %from the limits of x xaxis. 
        searchGrid.alpha  = linspace(min(StimLevels),max(StimLevels),101);
        %beta corresponds to the slope.  The magnitude of these can be very
        %different depending on the chosen psychometric function! 
        searchGrid.beta   = linspace(0,(30/max(xVal)),101);
        %Gamma is the guess rate. Going to set it to 50% for now
        searchGrid.gamma  = 0.5;
        %For fitting the lapse rate we'll use a 0 to 6% range. 
        searchGrid.lambda = linspace(0,.06,61);
    end
    
    %Now lets do the fit. Returning all results as cell arrays. 
    %All outputs here are named consistent with Palamedes naming
    %conventions
    %Consider changing both names and type. 
    [results.paramsValues{iGroup} results.LL{iGroup} results.exitflag{iGroup} results.output{iGroup}] = ...
        PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, ...
        searchGrid, paramsFree, PF,'lapseLimits',[0 .1], 'searchOptions',options);
    results.PF{iGroup}         = PF;
    results.StimLevels{iGroup} = StimLevels;
    results.NumPos{iGroup}     = NumPos;
    results.OutOfNum{iGroup}   = OutOfNum; 
    
    %Now lets evaluate the function so we can use for easy plotting:
    results.functionFitX{iGroup} = linspace(StimLevels(1),StimLevels(end),100);
    results.functionFitY{iGroup} = PF(results.paramsValues{iGroup}, results.functionFitX{iGroup});
    
    
    
end


results.paradigmName = participantData.sessionInfo.expInfo.paradigmName;
results.conditionLabels = conditionLabels;

if isfield(analysisOptions,'xlabel')
    results.xlabel = analysisOptions.xlabel;
else
    results.xlabel = xAxisField;
end


end

