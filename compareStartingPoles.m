    function [cases, res] = compareStartingPoles(filename)
%COMPARESTARTINGPOLES Compares different starting poles
% Function that compares different combinations of starting poles for
% vector fitting. At the moment it is not customizable
% Input:
%   filename: Name of the file containing the data
% Output:
%   cases: struct containing information about the cases
%   res: struc containing the results

% First read in the data
[sys1,sys2] = prepareCase(filename, [], 50);
% Setting up the cases

%% Case 1:Complex1
% In this case there is only complex starting poles linearly spaced up to 1
Betha = -linspace(0,1,10);
complexPoles = complex(Betha/100,Betha);
cases.complex1.complexPoles = complexPoles;
cases.complex1.realPoles = [];

%% Case 2:Real1
% In this case there is only real poles linearly spaced up to 10
cases.real1 = cases.complex1;
cases.real1.complexPoles = [];
cases.real1.realPoles = -linspace(0,1,10);

%% Case 3:compReal1
% In this case there are both real and comples poles
cases.compReal1 = cases.real1;
cases.compReal1.complexPoles = cases.complex1.complexPoles;

%% Case 7:Complex2
% In this case there are only complex starting poles linearly spaced
cases.complex2 = cases.complex1;
Betha = -linspace(0,6,10);
cases.complex2.complexPoles = complex(Betha/100,Betha);

%% Case 8:Real2
% In this case there are only complex starting poles linearly spaced
cases.real2 = cases.real1;
cases.real2.realPoles = Betha;

%% Case 11:compReal2
cases.compReal2 = cases.compReal1;
cases.compReal2.realPoles = Betha;
cases.compReal2.complexPoles = complex(Betha/100,Betha);

%% Case 9:Complex3
cases.complex3 = cases.complex2;
Betha = -linspace(0,0.5,10);
cases.complex3.complexPoles = complex(Betha/100,Betha);

%% Case 10:Real3
cases.real3 = cases.real2;
cases.real3.realPoles = Betha;

%% Case 14:compreal3
cases.compReal3 = cases.real3;
cases.compReal3.complexPoles = cases.complex3.complexPoles;

%% Case 12:Real4
cases.real4 = cases.real3;
cases.real4.realPoles = -linspace(0,0.1,10);

%% Case 13:Compplex4
cases.complex4 = cases.complex3;
Betha = -linspace(0,0.1,10);
cases.complex4.complexPoles = complex(Betha/100,Betha); 

%% Case 15:compreal4
cases.compReal4 = cases.complex4;
cases.compReal4.realPoles = cases.real4.realPoles;

%% Case 9:Complex5
cases.complex5 = cases.complex2;
Betha = -linspace(0,0.05,10);
cases.complex5.complexPoles = complex(Betha/100,Betha);

%% Case 10:Real5
cases.real5 = cases.real2;
cases.real5.realPoles = Betha;

%% Case 14:compreal5
cases.compReal5 = cases.real3;
cases.compReal5.complexPoles = cases.complex5.complexPoles;


names = fieldnames (cases);

cases.sys1 = sys1;
cases.sys2 = sys2;

%run the tests
for i = 1:numel(names)
    % Run vectorfitting
    res.(names{i}) = runVecFit(sys1.InputData, sys1.OutputData,...
        sys1.SamplingInstants, cases.(names{i}).complexPoles,...
        cases.(names{i}).realPoles);
end

% I realized that it would be practical to use cells
cellRes = cell(1,numel(names));
for i = 1:numel(names)
    cellRes{i} = res.(names{i}).fit;
end

cases.fit = doComparison(cases.sys2,cellRes,[],names);