function [ delay ] = estimateDelay( stimulus, response )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

opts = optimoptions(@lsqnonlin,'display','off')

myObj = @(param)(simpleDelay([param],stimulus)-response);
x0= [5];
[fitParam] = lsqnonlin(myObj,x0,[0],[inf],opts);

end

