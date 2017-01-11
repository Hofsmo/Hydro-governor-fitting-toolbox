function [f,P,Q,U,I] = readPMU(filename, delimiter)
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

idx = zeros(1,6);
labels = {'Frequency','Voltage A:Magnitude','Voltage A:Angle',...
    'Current A:Magnitude','Current A:Angle'};

fid = fopen(filename);
header = strsplit(fgets(fid),delimiter);
for i = 2:numel(idx)
    [~,idx(i)] = max(cellfun(@(s) ~isempty(strfind(s, labels{i-1})), header));
end
idx=idx(2:end)-1;
fclose(fid);

data = dlmread (filename, delimiter, 1, 1);

% Trunctate the data at the first nan value
[row, ~] = find(isnan(data));
if ~isempty(row)
    data = data(1:row(1)-1,:);
end

f = data(:,idx(1));
U = data(:,idx(2)).*(cos(data(:,idx(3))*pi/180) +1i*sin(data(:,idx(3))*pi/180));
I = -data(:,idx(4)).*(cos(data(:,idx(5))*pi/180) +1i*sin(data(:,idx(5))*pi/180));
P = real (U.*conj(I))*3/10^6;
Q = imag(U.*conj(I))*3/10^6;
P = P(~isnan(P));
