function [oriDiff contrast] = getRawOriDiff(experimentData)


for iTrial = 1:length(experimentData),
    
    ori1 = experimentData(iTrial).trialData.firstCond.stimOri;
    ori2 = experimentData(iTrial).trialData.secondCond.stimOri;
    
    oriDiff(iTrial) =  minAngleDiff(ori1,ori2);
    contrast(iTrial) = experimentData(iTrial).condInfo.contrast;
end

oriDiff = round(oriDiff,2);