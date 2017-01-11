    function [cases] = compareStartingPoles(filename,range)
%COMPARESTARTINGPOLES Compares different starting poles
% Function that compares different combinations of starting poles for
% vector fitting. At the moment it is not customizable
% Input:
%   filename: Name of the file containing the data
% Output:
%   cases: struct containing information about the cases
%   res: struc containing the results

% Setting up the cases

%% Case 1:Complex1
Betha = -2*pi*linspace(0,0.5,10);
cases.complex1.complexPoles = complex(Betha/100,Betha);
cases.complex1.realPoles = [];

%% Case 2:Real1
cases.real1.complexPoles = [];
cases.real1.realPoles = Betha;

%% Case 3:compreal1
cases.compReal1 = cases.real1;
cases.compReal1.complexPoles = cases.complex1.complexPoles;

%% Case 4:Complex2
cases.complex2 = cases.complex1;
Betha = -2*pi*linspace(0,0.1,10);
cases.complex2.complexPoles = complex(Betha/100,Betha); 

%% Case 5:Real2
cases.real2 = cases.real1;
cases.real2.realPoles = Betha;

%% Case 6:compreal2
cases.compReal2 = cases.complex2;
cases.compReal2.realPoles = cases.real2.realPoles;

%% Case 7:Complex3
cases.complex3 = cases.complex1;
Betha = -2*pi*linspace(0,0.05,10);
cases.complex3.complexPoles = complex(Betha/100,Betha);

%% Case 8:Real3
cases.real3 = cases.real1;
cases.real3.realPoles = Betha;

%% Case 9:compreal3
cases.compReal3 = cases.real3;
cases.compReal3.complexPoles = cases.complex3.complexPoles;

names = fieldnames (cases);
%run the tests
for i = 1:numel(names)
    % Run vectorfitting
    opt.realPoles = cases.(names{i}).realPoles;
    opt.complexPoles = cases.(names{i}).complexPoles;
    cases.(names{i}).parts = identifyPartitioned(filename, range, 0.02, 50, 'VF', opt);
end

