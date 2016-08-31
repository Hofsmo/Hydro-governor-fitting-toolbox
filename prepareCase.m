function [sys,validation] = prepareCase(filename, range, factor)
% PREPARECASE prepare the case for the identification
% A function that prepares the signal for the identification
% INPUT:
%   filename: Namme of the file containing the case
%   range: The range of values to use. The default is to use all
%   window: The window size used for smoothing the signal
%   factor: The factor used for decimation.
% OUTPUT:
%   sys: iddata object containing the system
%   validation: Data used for validation

[f,p] = readPMU(filename);

if nargin < 3
    factor = 0;
end

if nargin < 2 || isempty(range)
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
sys = resample(iddata(p,f,ts),1,factor);

if nargout == 2
    sys=iddata(sys.OutputData(1:floor(end/2)),sys.InputData(1:floor(end/2)),sys.Ts);
    validation=iddata(sys.OutputData(floor(end/2)+1:end),sys.InputData(floor(end/2)+1:end),sys.Ts);
end

end