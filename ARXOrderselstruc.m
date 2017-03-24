% Script that finds the best ARX order for all generators at different
% times
order=5;
ranges = [300, 600, 900, 1200];
tmp = ls();
names = tmp(3:end,:);
% Create struct for storing stuff
gen = struct('name',[],'snaps',[]);
% Initialize struct array
gen(size(names,1)).name = names(end,:);

% Run through all the generators
N = size(names,1);
for k=1:numel(ranges)
    h = waitbar(0,'Initializing waitbar...');
    for i=1:size(names,1)
        waitbar(i/N,h,sprintf('%d%%',floor(i/N*100)))
        cd (names(i,:))   
        gen(i).name = names(i,:);
        tmp = ls ();
        snaps = tmp(3:end,:);
        gen(i).snaps = struct('name',[],'models',[],'indicators', []);
        gen(i).snaps(size(names,1)).models = [];
        for j = 1:size(snaps,1)
            gen(i).snaps(j).name=snaps(j,:);
            [f, p] = readPMU(snaps(j,:));
            [data] = prepareCase(f, p, ranges(k), 50);

            NN = struc(1:order,1:order,0);
            opt = arxOptions('Focus', 'prediction');
            V = arxstruc(data{1}, data{2}, NN);
            [nn, vmod] = selstruc(V, 'aic');
            gen(i).snaps(j).model = arx(data{1}, nn, opt);
            [gen(1).snaps(j).NRMSE, gen(1).snaps(j).NRMSE_sim] = variance_accounted_for(data{2}, data{1});
        end
        cd ('..')
    end
    close(h)
    save(sprintf('../Transactions_results/ARXOrder_selstruc_%d.m', ranges(k)))
end
