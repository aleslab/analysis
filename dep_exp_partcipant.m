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
    
    
    
    estimate(i)=estimate(i-1) + gain*minAngleDiff(stimOri(i),estimate(i-1));
    
    sdEstimate(i)  = stimOri(i-1) + gain*minAngleDiff(stimOri(i),stimOri(i-1));
    
    estimate(i) = wrapTo90(estimate(i));
    
    err(i) = minAngleDiff(respOri(i), stimOri(i));%whitney
    
    RO(i)=  minAngleDiff (stimOri(i-1),stimOri (i));%whitney
    
    PE(i) = minAngleDiff(stimOri(i),estimate (i-1));%PE
    
    estimateUpdate(i) =  minAngleDiff(estimate(i),estimate (i-1));
    
    partcipantupdate(i) = minAngleDiff(respOri(i), respOri(i-1));
    
    sdErr(i) = minAngleDiff(sdEstimate (i), stimOri(i));%whitney
     
    
    
end


var_prox=var(err); % amount of variance in the error
var_dist=var(stimOri); %variance in the stimOri

figure(101);
clf
set (gca,'fontsize', 26);
hold on
plot (respOri,'r', 'Linewidth',3);
% hold on
% plot (stimOri,'r', 'Linewidth',2);
% hold on
plot (estimate,'k','Linewidth',3);
legend ('Response','Kalman');
xlabel('Time');
ylabel ('Orientation in degrees');

figure(102);
clf;
set(gca,'fontsize', 26);
hold on
scatter (RO, err,70,'k','filled');
legend ('Error on trial');
xlabel('Relative Orientation');
ylabel('Error in degrees');

figure (103);
clf;
set (gca,'fontsize', 22);
hold on
scatter (RO, PE,90,'k','filled');
legend ('Serial dependence');
xlabel ('RO');
ylabel('Prediction error in degrees');


figure (104);
clf;
set (gca,'fontsize', 22);
hold on
scatter (estimateUpdate, PE,50,'b','filled');
legend ('Response Update');
xlabel('How much the kalman updates');
ylabel ('Amount of prediction error');



figure(105);
clf;
set(gca,'fontsize', 22);
hold on
scatter (RO, sdErr,50,'g','filled');
legend ('whitney_sdErr')

figure(106);
clf;
set(gca,'fontsize', 22);
hold on
scatter (partcipantupdate, PE,50,'k','filled');
xlabel('How much the participant updates');
ylabel ('Amount of prediction error');
legend ('PE');




