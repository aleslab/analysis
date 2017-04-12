

function [ b, bint, r, p ] = analysis_func( X, Y)

X=X';
Y=Y';
%B=ctranspose(Y);

    
    
        %Calculate the correlation coefficient
        [ r,  p ]= circularSlope90d(x, y);
         %calyculate regression slopes
        myModel = cat(1,X,ones(size(X)))';
        myY     = y';
        [b, bint] = regress(myY, myModel);
        
end

        