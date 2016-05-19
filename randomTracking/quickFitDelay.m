
nCond = length(sortedTrialData);
fitData = struct();

for i=1:3,
    fitData(i).gain = [];
    fitData(i).delay = [];
    fitData(i).resnorm = [];
end

idx =1;

timePerFrame = sessionInfo.expInfo.frameDur;
for iCond = 1:nCond,
    nTrial = length(sortedTrialData(iCond).trialData);
    thisGain = allGains(iCond);
    for iTrial = 1:nTrial,
        
        
        input = (sortedTrialData(iCond).trialData(iTrial).stimOri)';
        response = (sortedTrialData(iCond).trialData(iTrial).respOri)';
        
        nChunks = floor(length(input)/chunkSize);
        inputChunked = reshape(input(1:nChunks*chunkSize),chunkSize,[])';
        responseChunked = reshape(response(1:nChunks*chunkSize),chunkSize,[])';
        
        for iChunk = 1:nChunks
            input = inputChunked(iChunk,:);
            response = responseChunked(iChunk,:);
            input = input -mean(input); %0 mean data
            response = response-mean(response); %0 mean data;
            
            %Check that they accurately did the task
            %     percentError = sum((input-response).^2)/sum(input.^2);
            %     if percentError > 10;
            %         pause;
            %     end
            
            myObj = @(delay)(simpleKalman([thisGain, delay],input)-response);
            x0= [10];
            [fitParam,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = ...
                lsqnonlin(myObj,x0,[0],[inf],opts);
            %
            %     myObj = @(param)(simpleDelay([param],input)-response);
            %     x0= [10];
            %     [fitParam,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = ...
            %     lsqnonlin(myObj,x0,[0],[inf],opts);
            
            %thisCond = experimentData(iTrial).condNumber;
            thisCond = iCond;
            fitData(thisCond).gain(end+1) = thisGain;
            fitData(thisCond).delay(end+1) = fitParam(1);%*timePerFrame;
%             [iCond iTrial]
%             [fitParam thisGain]
            %if fitParam(2) <0, keyboard, end
            fitData(thisCond).resnorm(end+1) = RESNORM;
            
            %xFit = simpleDelay([fitParam],input);
            % figure(42)
            % clf
            % plot(input)
            % hold on
            % plot(response)
            % plot(xFit);
            % %title(['Gain: ' num2str(fitParam(1)) ' Delay: ' num2str(fitParam(2)) ...
            % %    ' Contrast: ' num2str(sessionInfo.conditionInfo(thisCond).contrast)]);
            % pause;
        end
        
    end
    
end




