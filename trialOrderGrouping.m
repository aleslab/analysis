
ptbCorgiData = uiGetPtbCorgiData();


% 
reaction_times(reaction_times==0)=NaN;

meanRT=nanmean(reaction_times, 2);

meanRT=squeeze(meanRT);

meanRT=(meanRT');

%Data cond list
dataCond = [2 3 4 6 7 8];
%To create pairs;
dataNowCond = ...
   [1 1; ...
    3 4;...
    2 4;...
    2 3;...
    5 5;...
    7 8;...
    6 8;...
    6 7];

%Instruction list  of conditions to completely ignore
instrCond = [];
correctResponese = [ 'x' '3' 'x' '1' 'x' '3' 'x' '1'];


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
    for iPrevCond = dataCond,
        
        iNowCond = dataNowCond(iPrevCond,1);
        condPairId(idx,:) = [idx iPrevCond iNowCond];
        rtSubset = reaction_times(1,:,iPrevCond,iPpt);
        respSubset = RTBoxEvent(1,:,iPrevCond,iPpt);
        trlSelect=stimCondNum(1,:,iPrevCond,iPpt)==iNowCond;
        corrResp = correctResponese(iNowCond);
        
        pairedRt(trlSelect,idx,iPpt)= rtSubset(trlSelect);
        pairedRt(~trlSelect,idx,iPpt)= NaN;
        
        responseChosen(trlSelect,idx,iPpt) = respSubset(trlSelect);
        responseChosen(~trlSelect,idx,iPpt)= 'x';

        responseChoseA(trlSelect,idx,iPpt) = double(respSubset(trlSelect)=='3');
        responseChoseA(~trlSelect,idx,iPpt)= NaN;

        isRespCorrect(trlSelect,idx,iPpt) = double(respSubset(trlSelect)==corrResp);
        isRespCorrect(~trlSelect,idx,iPpt)= NaN;
        
        
        idx=idx+1;
        iNowCond = dataNowCond(iPrevCond,2);
        trlSelect=stimCondNum(1,:,iPrevCond,iPpt)==iNowCond;
        pairedRt(trlSelect,idx,iPpt)= rtSubset(trlSelect);
        pairedRt(~trlSelect,idx,iPpt)= NaN;
        corrResp = correctResponese(iNowCond);      
        
        responseChosen(trlSelect,idx,iPpt) = respSubset(trlSelect);
        responseChosen(~trlSelect,idx,iPpt)= 'x';

        responseChoseA(trlSelect,idx,iPpt) = double(respSubset(trlSelect)=='3');
        responseChoseA(~trlSelect,idx,iPpt)= NaN;

        isRespCorrect(trlSelect,idx,iPpt) = double(respSubset(trlSelect)==corrResp);
        isRespCorrect(~trlSelect,idx,iPpt)= NaN;
        
        condPairId(idx,:) = [idx iPrevCond iNowCond];
        idx=idx+1;
        
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

%1= expected task 1, 2= unexpected task 1, 3 = Z
%5 = expected task 2, 6 = unexpected task 2, 4 = Z task 2
trialLabel = [3 2 2 1 1 3 4 6 6 5 5 4]; 
eu=trialLabel; %Just to save typing
correctRTExUnex=[mean(onlyCorrectRT(:,eu==1)'); mean(onlyCorrectRT(:,eu==2)'); mean(meanRT(:,eu==3)'); mean(onlyCorrectRT(:,eu==5)'); mean(onlyCorrectRT(:,eu==6)'); mean(meanRT(:,eu==4)');]'
