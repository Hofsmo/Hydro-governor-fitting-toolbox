function res = identifyPartitioned(filename, range, ts, factor, method, opt)

if nargin < 4
    method = 'VF';
   if nargin < 6
       opt.realPoles = -linspace(0,1,10);
       Beta = opt.realPoles;
       opt.complexPoles = complex(Beta/100, Beta);
   end
end

if nargin < 4
    ts = 0.02;
end

if nargin < 5
    factor = 50;
end

sys = prepareCase(filename,range,factor,ts);

N = numel(sys);
pairs=nchoosek(1:N,2);
pairs = [pairs;fliplr(pairs)];
res.sys = sys;
res.pairs = pairs;
res.model = cell(1,size(pairs,1));
res.ident(size(pairs,1)).idx_i = pairs(end,1);
res.NRMSE = zeros(1,size(pairs,1));

for i = 1:size(pairs,1)

    if strcmp(method,'VF')
        res.model{i} = runVecFit(sys{pairs(i,1)}.InputData,...
            sys{pairs(i,1)}.OutputData, sys{pairs(i,1)}.SamplingInstants,...
            opt.complexPoles, opt.realPoles);
        [~,res.NRMSE(i),~] = compare(sys{pairs(i,2)}, res.model{i}.fit);
    end
end
        