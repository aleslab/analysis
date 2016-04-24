function output = simpleDelay(X,input);

delay = X(1);
nT = length(input);


%output = [x(1)*ones(delay,1); x(1:end-delay)];

output = interp1(1:nT,input,[1:nT]-delay,'linear','extrap');