function [p,f,t,ts] = prepareCase(filename, range, window, factor)
% PREPARECASE prepare the case for the identification
% A function that prepares the signal for the identification
% INPUT:
%   filename: Namme of the file containing the case
%   range: The range of values to use. The default is to use all
%   window: The window size used for smoothing the signal
%   factor: The factor used for decimation.
% OUTPUT:
%   p: The processed power
%   f: The processed frequency
%   t: The processed time
%   ts: The time step

[f,p] = readPMU(filename);

if nargin < 4
    factor = 0;
end

if nargin < 3
    window = 0;
end

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

% Smooth the signals
if window
    p = smooth(p,window);
    f = smooth(f,window);
end

% Decimate the signals
if factor
    p = decimate(p,factor);
    f = decimate(f,factor);
    t = decimate(t,factor);
    ts = t(2)-t(1);
end