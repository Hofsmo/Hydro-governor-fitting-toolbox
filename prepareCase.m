function [data] = prepareCase(f, p, range, factor, ts)
% PREPARECASE prepare the case for the identification
% A function that prepares the signal for the identification
% INPUT:
%   filename: Namme of the file containing the case
%   range: The range of values to use in seconds
%   window: The window size used for smoothing the signal
%   factor: The factor used for decimation.
%   ts: sample rate
%   PMU: Does the data come from a PMU? If it does calculate the power from
%   voltage and current. If not assume that the power is already calculated
% OUTPUT:
%   sys: iddata object containing the system
%   validation: Data used for validation

if nargin < 5
    ts = 0.02;
end

if nargin < 4
    factor = 0;
end

if nargin < 2 || isempty(range)
    data = resample(detrend(iddata(p,f,ts)),1,factor);
else     
    if numel(f)*ts < range * 2
        warning ('Chosen time window longer than half of dataset');
        sets = 1;
        range=range/ts;
    else
          range=range/ts;
          N = numel(f);  
          sets = floor(N/range);
    end
    data = cell(1,sets);
    for i = 1:sets
        idx = 1+(i-1)*range:i*range;
        data{i} = resample(detrend(iddata(p(idx),f(idx),ts)),1,factor);
    end
end
