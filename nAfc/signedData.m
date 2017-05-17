validTrial = [ptbCorgiData.participantData.experimentData.validTrial]
[oriDiff contrast] = getRawOriDiff(ptbCorgiData.participantData(1).experimentData(validTrial));
choice = [ptbCorgiData.participantData(1).experimentData.chosenInterval]-1;

[contrast,contrastSortIdx] = sort(contrast);


choice = choice(contrastSortIdx);
oriDiff = oriDiff(contrastSortIdx);


contrastList = unique(contrast);
stimLevels = sort(unique(oriDiff));

figure
for iContrast = 1:length(contrastList),
    for iStimLevels = 1:length(stimLevels),
        
    selectedTrials = (contrast == contrastList(iContrast) ) & (oriDiff == stimLevels(iStimLevels));
    
    
    
    nPos(iContrast,iStimLevels)  = sum(choice(selectedTrials));
    outOf(iContrast,iStimLevels) = sum(selectedTrials);

    end
    
    plot2afc(stimLevels,nPos(iContrast,:),outOf(iContrast,:))
    hold on;
    
end



