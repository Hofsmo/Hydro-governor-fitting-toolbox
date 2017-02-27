% Script that finds the best ARMAX order for all generators at different
% times

tmp = dir();
names = tmp(3:end,:);
% Create struct for storing stuff
gen = struct('name',[],'snaps',[]);
% Initialize struct array
gen(size(names,1)).name = names(end,:);

% Run through all the generators
h = waitbar(0,'Initializing waitbar...');
N = size(names,1);
for i=1:size(names,1)
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
        [data] = prepareCase(f, p, 300, 50);
        NN = [struc(1:10,1:10,1:10),zeros(10^3,1)];
        
        opt = armaxOptions('Focus', 'simulation');
        [gen(i).snaps(j).models,gen(i).snaps(j).indicators]...
            = findARMAXOrder(data{1},data{2},NN,2,opt);
    end
    cd ('..')
end
save ARMAXOrder_300.m