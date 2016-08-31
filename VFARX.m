    % Script to compare Thuc's paper with vector fitting

% First read in the data

[p1,f1,t,ts] = prepareCase('150916-Kvilldal-T4-5-Normal.csv', 1:2200*50);
% Setting up the cases

%% Case raw
% In this case we work on the raw data. The only thing that has been done
% is to remove the dc offset.
Betha = -linspace(0,0.1,10);
complexPoles = complex(Betha/100,Betha);
cases.raw.complexPoles = complexPoles;
cases.raw.realPoles = [];
cases.raw = createVFARXStruct(p1,f1,t,cases.raw);

%% Case smooth
% In this case the data is smoothed.
cases.smooth = cases.raw;
cases.smooth = createVFARXStruct(p1,f1,t,cases.smooth,200);

%% Case decimate
% In this case the data is both smoothed and decimated
cases.decimate = cases.smooth;
cases.decimate = createVFARXStruct(cases.smooth.p, cases.smooth.f,...
    cases.smooth.t, cases.decimate, [], 10);

%% Case window size 100
% In this case the averaging window is decreased
cases.w100 = cases.raw;
cases.w100 = createVFARXStruct(cases.raw.p, cases.raw.f, cases.raw.t,...
    cases.w100, 100, 10);

%% Case window size 300
% In this case the averaging window is increased
cases.w300 = cases.raw;
cases.w300 = createVFARXStruct(cases.raw.p, cases.raw.f, cases.raw.t,...
    cases.w300, 300, 10);

%% Case window size 400
% In this case the averaging window is increased
cases.w400 = cases.raw;
cases.w400 = createVFARXStruct(cases.raw.p, cases.raw.f, cases.raw.t,...
    cases.w400, 400, 10);

%% Case window size 500
% In this case the averaging window is increased
cases.w500 = cases.raw;
cases.w500 = createVFARXStruct(cases.raw.p, cases.raw.f, cases.raw.t,...
    cases.w500, 500, 10);

%% Case window size 600
% In this case the averaging window is increased
cases.w600 = cases.raw;
cases.w600 = createVFARXStruct(cases.raw.p, cases.raw.f, cases.raw.t,...
    cases.w600, 600, 10);

%% Case window size 700
% In this case the averaging window is increased
cases.w700 = cases.raw;
cases.w700 = createVFARXStruct(cases.raw.p, cases.raw.f, cases.raw.t,...
    cases.w700, 700, 10);

% Case deicmate and cut
% In this case remove the 200 first and last samples before decimating
cases.cut = cases.smooth;
cases.cut.f = decimate(cases.smooth.f(200:end-200),10);
cases.cut.p = decimate(cases.smooth.p(200:end-200),10);
cases.cut.t = decimate(cases.smooth.t(200:end-200),10);
cases.cut.td = iddata(cases.cut.p,cases.cut.f, cases.cut.t(2)-cases.cut.t(1));

% Case three fourth window
n = 1:floor(numel(cases.decimate.t)*3/4);
cases.redRange = cases.decimate;
cases.redRange = createVFARXStruct(cases.decimate.p(n),cases.decimate.f(n),...
    cases.decimate.t(n),cases.redRange);

% Case half window
n = 1:floor(numel(cases.decimate.f)/2);
cases.halfRange = cases.decimate;
cases.halfRange = createVFARXStruct(cases.decimate.p(n),cases.decimate.f(n),...
    cases.decimate.t(n),cases.halfRange);

names = fieldnames (cases);

% run the tests
for i = 1:numel(names)
    % Run vectorfitting
    res.(names{i}).vf = runVecFit(cases.(names{i}).f, cases.(names{i}).p,...
        cases.(names{i}).t, cases.(names{i}).complexPoles,...
        cases.(names{i}).realPoles);
    % Run ARX
    res.(names{i}).arx = runARX(cases.(names{i}).td);    
    doComparison(cases.(names{i}).td,{res.(names{i}).vf.fit,res.(names{i}).arx.fit},...
        names{i},{'VF','ARX'});
end
