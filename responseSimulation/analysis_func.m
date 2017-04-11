

%function [ b, bint, r, p ] = analysis_func( input_1, input_2)


    function [ b, bint, r, p] = circularSlope90d( input_1,input_2 )
    
        %Calculate the correlation coefficient
        [r,  p ]= corr(input_1, input_2);
         %calyculate regression slopes
        myModel = cat(1,input_1,ones(size(input_1)))';
        myY     = input_2';
        [b, bint] = regress(myY, myModel);
        
end

        