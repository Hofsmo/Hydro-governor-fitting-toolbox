function [p,f,t,ts] = prepareCase(filename, range)

[f,p] = readPMU(filename);

if nargin < 2
    f1 = f;
    p1 = p;
else
    f1 = f(range);
    p1 = p(range);
end

% Remove dc offset
hDC3 = dsp.DCBlocker('Algorithm','Subtract mean');
f = -step(hDC3,f1);
p = step(hDC3,p1);

ts = 0.02;
t=0:ts:((length(f1)-1)*ts);