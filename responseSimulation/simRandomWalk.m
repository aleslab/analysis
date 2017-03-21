dclear all;
rng('default')
nTrials = 300;
stim = cumsum(randn(1,nTrials)*10);
stim = wrapTo90(stim);

weights = [.5 .5];
nWeight = length(weights);

resp = simStimAve(stim,weights);
resp = wrapTo90(resp);

err = minAngleDiff(resp(nWeight:end), stim(nWeight:end));

nBack = 5;
for iBack = 1:nBack,
    
    idx = (nBack+1+nWeight-2):nTrials;
    RO(iBack,:) = minAngleDiff ( stim(idx-iBack),stim(idx ));%whitney
end


[r,p] = corrcoef([err(nBack:end)' RO']);
r(1,:)
p(1,:)

model = [];
nBack = 10;
% for iBack = 1:nBack,
%     idx = (nBack+1+nWeight-2):nTrials;
%     model = cat(1,model, stim( idx  - iBack +1));
% end
% model = cat(1,model,ones(1,size(model,2)));

tm = toeplitz(stim);
model = tm(nBack:end,1:nBack);
model = cat(2,model,ones(size(model,1),1));

[b, bint] = regress( (resp(nBack:end)'), (model));
w=fitCircular(stim,[resp],nBack);

b'
w'

