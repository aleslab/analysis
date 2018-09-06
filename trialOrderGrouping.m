
ptbCorgiData = uiGetPtbCorgiData();




%Data cond list
dataCond = [1 2 3 ];
%To create pairs;cl
dataNowCond = ... % in cons 1-4 (ABCD); match pairs so they go to there most likely pair A goes to B, B goes to C and C goes to A
   [1 1; ...
    1 2;...
    1 3;...
    2 1;...
    2 2;...
    2 3;...
    3 1;...
    3 2;...
    3 3];

%Instruction list  of conditions to completely ignore
instrCond = [4 8]; % ignore omitted cons in this analysis
correctResponese = [ '1' '2' '3' 'b' 'x' '1' '2' '3' 'b'];


for iPpt = 1:ptbCorgiData.nParticipants,

    thisPptData = ptbCorgiData.participantData(iPpt).experimentData;
    condList = [thisPptData.condNumber];
    
    for iCond = 1:8,
        
        %Find trials for this condition
        trialIdx = find(condList==iCond);
        %Trim last trial because there's no next trial. 
        if trialIdx(end)==length(condList)
            trialIdx = trialIdx(1:end-1);
        end
        %Index into trials following the selected condition.
        trialIdx = trialIdx+1;
        
        instructionTrials = find(ismember(condList,instrCond));
        %make sure to exclude instruction trials
        trialIdx = setdiff(trialIdx,instructionTrials);
        
        
        
        trialData = [thisPptData(trialIdx).trialData];
        nTrial = length(trialIdx);
        
        for iTrl=1:nTrial
            
            stimStartTime(1,iTrl,iCond,iPpt) = trialData(iTrl).stimStartTime;
            valid_trials(1,iTrl,iCond,iPpt) = trialData(iTrl).validTrial;
            if trialData(iTrl).validTrial           
            RTBoxGetSecsTime(1,iTrl,iCond,iPpt) = trialData(iTrl).RTBoxGetSecsTime(1);
            RTBoxEvent(1,iTrl,iCond,iPpt) = char(trialData(iTrl).RTBoxEvent(1));
            stimCondNum(1,iTrl,iCond,iPpt) = condList(trialIdx(iTrl));
            else
                RTBoxGetSecsTime(1,iTrl,iCond,iPpt) = NaN;
                RTBoxEvent(1,iTrl,iCond,iPpt) = '!';
                stimCondNum(1,iTrl,iCond,iPpt) = condList(trialIdx(iTrl));
            end
            
            
        end

% 
    end

end

reaction_times = RTBoxGetSecsTime(1,:,:,:) - stimStartTime; 
reaction_times(reaction_times==0)=NaN;

clear pairedRt isRespCorrect
for iPpt = 1:ptbCorgiData.nParticipants,
    
    %For A first
    
    idx = 1;
    for iPair = 1:length(dataNowCond),
        
        iPrevCond = dataNowCond(iPair,1);
        iNowCond = dataNowCond(iPair,2);
        condPairId(iPair,:) = [iPair iPrevCond iNowCond];
        rtSubset = reaction_times(1,:,iPrevCond,iPpt);
        respSubset = RTBoxEvent(1,:,iPrevCond,iPpt);
        trlSelect=stimCondNum(1,:,iPrevCond,iPpt)==iNowCond;
        corrResp = correctResponese(iNowCond);
        
        pairedRt(trlSelect,iPair,iPpt)= rtSubset(trlSelect);
        pairedRt(~trlSelect,iPair,iPpt)= NaN;
        
        responseChosen(trlSelect,iPair,iPpt) = respSubset(trlSelect);
        responseChosen(~trlSelect,iPair,iPpt)= 'x';

        responseChoseA(trlSelect,iPair,iPpt) = double(respSubset(trlSelect)=='3');
        responseChoseA(~trlSelect,iPair,iPpt)= NaN;

        isRespCorrect(trlSelect,idx,iPpt) = double(respSubset(trlSelect)==corrResp);
        isRespCorrect(~trlSelect,idx,iPpt)= NaN;
        
        
     
        
    end
    
    
end

%List 
disp('[ index firstCond secondCond]');
condPairId

disp('mean reaction time across trials')
meanRT = squeeze(nanmean(pairedRt,1))'

disp('number of trials')
numberTrials = squeeze(nansum(pairedRt>0))'

disp('Percent Correct')
percCorr= squeeze(nanmean(isRespCorrect))'

disp('Percent pressed ''a'' ')
percA = squeeze(nanmean(responseChoseA(:,:,:)))'

disp ('total number of trials per screen posistion')
% totalPerCon= sum(trialIdx)

