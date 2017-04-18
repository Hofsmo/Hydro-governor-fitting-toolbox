% Script that finds the best ARX order for all generators at different
% times
order = 10;
ranges = [300, 600, 900, 1200, 1800];

for k = 1:numel(ranges)
    tmp = dir();
    names = tmp(3:end,:);
    % Create struct for storing stuff
    gen = struct('name',[],'snaps',[]);
    % Initialize struct array
    gen(size(names,1)).name = names(end,:);

    h = waitbar(0,'Initializing waitbar...');
    % Run through all the generators
    N = size(names,1);
    for i=1:N
        waitbar(i/N,h,sprintf('%d%%',floor(i/N*100)))
        cd (names(i).name)   
        gen(i).name = names(i).name;
        tmp = dir();
        snaps = tmp(3:end,:);
        gen(i).snaps = struct('name',[],'models',[],'indicators', []);
        gen(i).snaps(size(names,1)).models = [];
        for j = 1:size(snaps,1)
            gen(i).snaps(j).name=snaps(j).name;
            [f, p] = readPMU(snaps(j).name);
            [data] = prepareCase(f, p, ranges(k), 50);
            NN = struc(1:order,1:order,0);

            opt = arxOptions('Focus', 'prediction');
            [gen(i).snaps(j).models,gen(i).snaps(j).indicators]...
                = findARXOrder(data{1},data{2},NN,2,opt);
        end
        cd ('..')
    end
    close(h)
    save (sprintf('../Transactions_results/ARXOrder_%d.mat', ranges(k)));
end
