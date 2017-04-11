

function [ b, bint, r, p ] = analysis_func( X, Y)


%[ b, bint, r, p] = circularSlope90d( Y,X )
    
        %Calculate the correlation coefficient
        [r,  p ]= circularSlope90d(X, Y);
         %calyculate regression slopes
        myModel = cat(1,X,ones(size(X)))';
        myY     = Y';
        [b, bint] = regress(myY, myModel);
        
end

        