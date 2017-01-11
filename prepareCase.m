function [sys,validation] = prepareCase(filename, range, factor, ts, PMU)
% PREPARECASE prepare the case for the identification
% A function that prepares the signal for the identification
% INPUT:
%   filename: Namme of the file containing the case
%   range: The range of values to use. The default is to use all
%   window: The window size used for smoothing the signal
%   factor: The factor used for decimation.
%   PMU: Does the data come from a PMU? If it does calculate the power from
%   voltage and current. If not assume that the power is already calculated
% OUTPUT:
%   sys: iddata object containing the system
%   validation: Data used for validation

if nargin < 4
    ts = 0.02;
end

if nargin < 5
    PMU = true;
end

if PMU
    [f,p] = readPMU(filename);
else
    [f,p] = readSimulation(filename);
end

if nargin < 3
    factor = 0;
end

if nargin < 2 || isempty(range) || strcmp('all', range)
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

temp = resample(iddata(p,f,ts),1,factor);

if nargout == 2
    sys=iddata(temp.OutputData(1:floor(end/2)),temp.InputData(1:floor(end/2)),temp.Ts);
    validation=iddata(temp.OutputData(floor(end/2)+1:end),temp.InputData(floor(end/2)+1:end),temp.Ts);
else
    sys = temp;
end

end