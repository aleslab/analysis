fileToLoad = uigetfile; load(fileToLoad);
[sortedData] = organizeData(sessionInfo,experimentData);

iCond =1; %When you have only 1 condition
respOri = [sortedData(iCond).trialData(:).respOri];
stimOri = [sortedData(iCond).trialData(:).stimOri];

% respOri = [sortedData.trialData(:).respOri];% when we have one condition
% stimOri = [sortedData.trialData(:).stimOri];

respOri=wrapTo90(respOri);
stimOri=wrapTo90(stimOri);
%p_response = respOri;

estimate(1)=0;
PE(1)=0;

RO(1)=0;
update(1)=0;
k_update(1)=0;


gain = 0.9;


for i= 2:length (stimOri);
    
    estimate(i)=estimate(i-1);
    estimate(i)=estimate(i-1) + gain*minAngleDiff(stimOri(i),estimate(i-1));
    PE(i) = minAngleDiff(stimOri(i),respOri(i-1));
    k_PE(i) = minAngleDiff(stimOri(i)+randn*10,estimate(i-1));
    RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
    update(i)=  minAngleDiff(respOri(i),respOri (i-1));
    k_update(i)= minAngleDiff(estimate(i),estimate(i-1));
end
    
figure(101);
clf;
plot (respOri);
hold on
plot (stimOri, 'x');
hold on
plot (estimate);
legend ('p_response', 'actual_stimOri', 'modelled kalman resposne given calibrated gain')
xlabel('trial number')
ylabel ('orientation');

figure (102);clf;
scatter (RO, PE,'b','filled');
legend ('prediction error');
xlabel ('RO');
ylabel('amount of prediciton error');


figure (103);clf;
scatter (update, PE,'b','filled');
legend ('responseUpdate vs PE');
xlabel('how much the estimate updates');
ylabel ('amount of prediction error');


figure (104);
scatter (k_update, PE,'b','filled');
legend('kalman_update vs PE');
xlabel('how much the kalman updates');
ylabel ('amount of prediction error');



