% Script that finds the best startingpoles order for all generators at different
% times

tmp = dir();
names = {tmp(3:end).name};
% Create struct for storing stuff
gen = struct('name',[],'snaps',[]);
% Initialize struct array
gen(size(names,1)).name = names(end,:);

ranges = [300];
saveNames = {'VF5Min'};

for k = 1:numel(ranges)
    % Create struct for storing stuff
    gen = struct('name',[],'snaps',[]);
    % Initialize struct array
    gen(size(names,1)).name = names(end,:);
    % Run through all the generators
    parfor i=1:numel(names)
        cd (names{i})    
        gen(i).name = names{i};
        tmp = dir ();
        snaps = {tmp(3:end).name};
        gen(i).snaps = struct('name',[],'res',[]);
        gen(i).snaps(size(snaps,1)).name = [];
        for j = 1:numel(snaps)
            gen(i).snaps(j).cases = compareStartingPoles(...
                snaps{j},ranges(k));
            gen(i).snaps(j).name= snaps{j};
        end
        cd('..');
    end
    save (sprintf('../%s',saveNames{k}))
end