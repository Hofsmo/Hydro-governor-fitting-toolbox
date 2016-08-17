fname = 'initPolesPaper.csv';
fid = fopen(fname,'w');

fprintf(fid, 'Generator;Snapshot');
names = fieldnames(gen(1).snaps(1).res);
for i = 1:numel(names)
    fprintf(fid, ';%s',names{i});
end
for i = 1:numel(names)
    fprintf(fid, ';%d',i);
end

fprintf(fid,'\n');
N = numel(gen);

for i = 1:N
    M = numel(gen(i).snaps);
    for j = 1:M           
        fprintf(fid,'gen-%d;snap-%d',i,j);
        for k = 1:numel(names)
            fprintf(fid,';%f',gen(i).snaps(j).cases.fit{k});
        end
        for k = 1:numel(names)
            fprintf(fid,';%s',gen(i).snaps(j).cases.fit{k});
        end
        fprintf(fid,'\n');
    end
end
fclose(fid);