distalVar = 133; %Set by us
proximalVar = 70; %The number you sent me. 
 
theoryP=.5*(distalVar + sqrt(distalVar).*sqrt(distalVar+4*proximalVar))

theoryK = (theoryP./(theoryP+proximalVar))
