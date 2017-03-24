function res = identifyPartitioned(filename, range, ts, factor, method, opt)

if nargin < 5
    method = 'VF';
   if nargin < 6
       opt.realPoles = -2*linspace(0,0.05,10);
       Beta = opt.realPoles;
       opt.complexPoles = complex(Beta/100, Beta);
   end
end

if nargin < 3
    ts = 0.02;
end

if nargin < 4
    factor = 50;
end
[f, p] = readPMU(filename);
sys = prepareCase(f, p, range, factor, ts);

N = numel(sys);
pairs=nchoosek(1:N,2);
pairs = [pairs;fliplr(pairs)];
res.sys = sys;
res.pairs = pairs;
res.model = cell(1,size(pairs,1));
res.NRMSE = zeros(1,size(pairs,1));
res.best.pair = [];
res.best.model = [];

for i = 1:size(pairs,1)

    if strcmp(method,'VF')
        res.model{i} = runVecFit(sys{pairs(i,1)}.InputData,...
            sys{pairs(i,1)}.OutputData, sys{pairs(i,1)}.SamplingInstants,...
            opt.complexPoles, opt.realPoles);
        [~,res.NRMSE(i),~] = compare(sys{pairs(i,2)}, res.model{i}.fit);
    end
    if strcmp(method, 'ARX')
        arxopt = arxOptions('Focus', 'prediction');
        V = arxstruc(sys{pairs(i,1)},sys{pairs(i,2)},opt.NN); % Test all the orders
        order = selstruc(V,0); % Select the best order
        res.model{i} = arx(sys{pairs(i,1)},order,arxopt); % Do the fitting
        
        %[~,res.NRMSE(i),~] = compare(sys{pairs(i,2)}, res.model{i});
        if isempty(best.model)
            res.best.model = res.model{i};
            res.best.model.pari = i;
            
            
    end 
end
        