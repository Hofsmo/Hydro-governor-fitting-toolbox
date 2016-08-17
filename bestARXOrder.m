% Script that finds the best ARX order for all generators at different
% times

tmp = ls();
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
    cd (names(i,:))   
    gen(i).name = names(i,:);
    tmp = ls ();
    snaps = tmp(3:end,:);
    gen(i).snaps = struct('name',[],'models',[],'indicators', []);
    gen(i).snaps(size(names,1)).models = [];
    for j = 1:size(snaps,1)
        gen(i).snaps(j).name=snaps(j,:);
            [sys1,sys2] = prepareCase(snaps(j,:), [], 50);
        NN = struc(1:30,1:30,0);
        opt = arxOptions('Focus', 'stability');
        [gen(i).snaps(j).models,gen(i).snaps(j).indicators]...
            = findARXOrder(sys1,sys2,NN,2,opt);
    end
    cd ('..')
end
