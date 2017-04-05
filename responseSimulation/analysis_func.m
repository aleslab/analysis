

function [ response ] = analysis_func %( stimOri, weights )


%%%%starting here%%%
    
        %Calculate the correlation coefficient
        [r p ]= corrcoef(RO, err);
         %calyculate regression slopes
        myModel = cat(1,RO,ones(size(RO)))';
        myY     = err';
        [b bint] = regress(myY, myModel);
        
end
        %%%%ending here%%%%
        
        %variables being used are error on current trial and RO of current
        %trial compared to previous trial
        
        