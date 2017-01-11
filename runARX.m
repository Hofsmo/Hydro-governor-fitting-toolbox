function ARX = runARX(responseData )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    opt = arxOptions('Focus','stability');
    tic
    ARX.fit=arx(responseData,[15 15 0],opt);
    ARX.time = toc;

end

