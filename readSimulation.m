function [f,P] = readSimulation(filename, delimiter)
% READPMU reads and processes PMU data
%
% INPUT:
%   filename: Name of the file containing the data
%   delimiter: Field delimiter character
%
% OUTPUT:
%   f: frequency
%   P: Power
%   U: Voltage
%   I: Current

if nargin < 2
    delimiter = ',';
end

idx = zeros(1,2);
labels = {'Frequency','Power'};

fid = fopen(filename);
header = strsplit(fgets(fid),delimiter);
for i = 1:numel(idx)
    [~,idx(i)] = max(cellfun(@(s) ~isempty(strfind(s, labels{i})), header));
end
fclose(fid);
idx = idx(:)-1;
data = dlmread (filename, delimiter, 1, 1);

f = data(:,idx(1));
P = data(:,idx(2));
