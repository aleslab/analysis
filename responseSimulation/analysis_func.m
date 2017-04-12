

function [ b, bint, r, p ] = analysis_func( X, Y)

X=X';
%B=ctranspose(Y);

    
    
        %Calculate the correlation coefficient
        [ r,  p ]= corr(X, Y);
         %calyculate regression slopes
        myModel = cat(1,X,ones(size(X)))';
        myY     = Y';
        [b, bint] = regress(myY, myModel);
        
end

        