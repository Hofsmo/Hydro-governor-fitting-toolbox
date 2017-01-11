% Script that finds the best startingpoles order for all generators at different
% times

tmp = dir();
names = {tmp(3:end).name};
% Create struct for storing stuff
gen = struct('name',[],'snaps',[]);
% Initialize struct array
gen(size(names,1)).name = names(end,:);

% Run through all the generators
for i=1:numel(names)
    cd (names{i})    
    gen(i).name = names{i};
    tmp = dir ();
    snaps = {tmp(3:end).name};
    gen(i).snaps = struct('res',[],'time',[],name,'');
    gen(i).snaps(numel(snaps)).name = '';
    for j = 1:numel(snaps)
        gen(i).snaps(j).name = snaps{j};
        tic
        gen(i).snaps(j).res = identifyPartitioned(snaps{j}, 600);
        gen(i).snaps(j).time = toc;
        
    end
    cd('..');
end