fileToLoad = uigetfile; load(fileToLoad); % loads up file you want 


%as far as i can see we want the true motion direction and the percieved
%direction which i assume is answrr?
motion_direction = data{1}.motion_direction*360/pi;
perceived_direction = data{1}.answer*360/pi; 
predicted_direction = data{1}.pred_direction* 360/pi; 
% now this is where i am stuck maybe becasuse i am not understanding the
% structure. I want to grab the two predicted conditions which are 1.09 &
% 0.46 which i presume are category 4 and 2?

%[errors[length



results = zeros(5,2)
for iBlock = 1:length(data)
for iTrial = 1:data{iBlock}.number_trials
    % sort trials into the correct bins
end
end

%or:

trialMatrix = [];
for iBlock = 1:length(data)
    trialMatrix = [trialMatrix ; [data{iBlock}.motion_direction_cat' (data{iBlock}.pred_direction_cat')/2 data{iBlock}.answer' * (360/(2*pi))]]
end

results = zeros(5,2)
results_error = zeros(5,2)
for iDir = 1:5
    for iPred = 1:2
        results(iDir,iPred) = median(trialMatrix(trialMatrix(:,1) == iDir & trialMatrix(:,2) == iPred,3))
        results_error(iDir,iPred) = std(trialMatrix(trialMatrix(:,1) == iDir & trialMatrix(:,2) == iPred,3)) / sqrt(sum(trialMatrix(trialMatrix(:,1) == iDir & trialMatrix(:,2) == iPred)))
    end
end

figure;
plot(results)

figure;
plot(data{1}.motion_direction_range*(360/(2*pi)), results)

figure;
x_data = [data{1}.motion_direction_range'*(360/(2*pi)) data{1}.motion_direction_range'*(360/(2*pi))]
errorbar(x_data, results, results_error)

