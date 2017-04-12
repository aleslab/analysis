

function [ b, bint, r, p ] = analysis_func( X, Y)


%B=ctranspose(Y);

    
    
        %Calculate the correlation coefficient
        [ r,  p ]= circularSlope90d(X, B);
         %calyculate regression slopes
        myModel = cat(1,X,ones(size(X)))';
        myY     = B';
        [b, bint] = regress(myY, myModel);
        
end

        