

function [ r, p, b, bint ] = analysis_func ( input_1, input_2)


%[ b, bint, r, p] = circularSlope90d( Y,X )
    
        %Calculate the correlation coefficient
        [b, bint, r,  p ]= circularSlope90d(input_1, input_2);
         %calyculate regression slopes
        myModel = cat(1,input_1,ones(size(input_1)))';
        myY     = input_2';
        [b bint] = regress(myY, myModel);
        
end

        