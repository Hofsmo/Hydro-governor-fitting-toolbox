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
[f,p] = readPMU(filename);

f1 = f(1:2200*50);
p1 = p(1:2200*50);
range = 1:numel(f1);

% Remoce dc offset
hDC3 = dsp.DCBlocker('Algorithm','Subtract mean');
f1 = -step(hDC3,f1);
p1 = step(hDC3,p1);

% Actual response
ts = 0.02;
t=[0:ts:((length(f1)-1)*ts)];

% Setting up the cases

%% Case 1:Complex1
% In this case there is only complex starting poles linearly spaced up to 1
Betha = -linspace(0,1,10);
complexPoles = complex(Betha/100,Betha);
cases.complex1.complexPoles = complexPoles;
cases.complex1.realPoles = [];
cases.complex1.sys = iddata(p1,f1,ts);
cases.complex1.f = decimate(smooth(f1,200),10);
cases.complex1.p = decimate(smooth(p1,200),10);
cases.complex1.t = decimate(t,10);
cases.complex1.td = iddata(p1,f1,ts);


%% Case 2:Real1
% In this case there is only real poles linearly spaced up to 10
cases.real1 = cases.complex1;
cases.real1.complexPoles = [];
cases.real1.realPoles = -linspace(0.1,10);

%% Case 3:compReal1
% In this case there are both real and comples poles
cases.compReal1 = cases.real1;
cases.compReal1.complexPoles = cases.complex1.complexPoles;

%% Case 4:Complex2
% In this case there are only complex starting poles logarithmically spaced
cases.complex2 = cases.complex1;
Betha = -logspace(log10(0.001),log10(1),10);
cases.complex2.complesPoles = complex(Betha/100,Betha);

%% Case 5:Real2
% In this case there are only real starting poles logarithmically spaced
cases.real2 = cases.real1;
cases.real2.realPoles = Betha;

%% Case 6:compReal2
cases.compReal2 = cases.real1;
cases.compReal2.realPoles = Betha;
cases.compReal2.complexPoles = cases.complex2.complexPoles;

%% Case 7:Complex3
% In this case there are only complex starting poles linearly spaced
cases.complex3 = cases.complex2;
Betha = -linspace(0,6,10);
cases.complex3.complexPoles = complex(Betha/100,Betha);

%% Case 8:Real3
% In this case there are only complex starting poles linearly spaced
cases.real3 = cases.real1;
cases.real3.realPoles = Betha;

%% Case 9:Complex4
cases.complex4 = cases.complex3;
Betha = -linspace(0,0.5,10);
cases.complex4.complexPoles = complex(Betha/100,Betha);

%% Case 10:Real4
cases.real4 = cases.real3;
cases.real4.realPoles = Betha;

%% Case 11:compReal3
cases.compReal3 = cases.compReal2;
cases.compReal3.realPoles = -linspace(0,0.5,10);
Betha = -linspace(0,1,10);
cases.compReal3.complexPoles = complex(Betha/100,Betha);

%% Case 12:Real5
cases.real5 = cases.real4;
cases.real5.realPoles = -linspace(0,0.1,10);

%% Case 13:Compplex5
cases.complex5 = cases.complex4;
Betha = -linspace(0,0.1,10);
cases.complex5.complexPoles = complex(Betha/100,Betha); 

%% Case 14:compreal4
cases.compReal4 = cases.real5;
cases.compReal4.complexPoles = cases.complex5.complexPoles;

%% Case 15:compreal5
cases.compReal5 = cases.compReal4;
cases.compReal5.realPoles = cases.real4.realPoles;

names = fieldnames (cases);

%run the tests
for i = 1:numel(names)
    % Run vectorfitting
    res.(names{i}) = runVecFit(cases.(names{i}).f, cases.(names{i}).p,...
        cases.(names{i}).t, cases.(names{i}).complexPoles,...
        cases.(names{i}).realPoles,1e-5);
end

% I realized that it would be practical to use cells
cellRes = cell(1,numel(names));
for i = 1:numel(names)
    cellRes{i} = res.(names{i}).fit;
end

doComparison(cases.complex1.td,cellRes);