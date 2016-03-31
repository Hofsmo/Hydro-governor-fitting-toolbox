function doComparison(sys, results, name, legends, toFile)
if nargin < 5
    toFile = false;
end
if nargin < 3
    name ='';
end
if nargin < 4
    legends = 'show';
end
if iscell(results)
    temp=cellfun(@(x) x*50/320, results,'UniformOutput', false);
    bode(temp{:})
    legend(legends)
    grid on
    title (name)
    
    if toFile
        print (name, '-jpeg')
    end
    
    compare(sys,results{:})
    legend(legends)
    
    if toFile
        print(name, '-jpeg')
    end
    figure
    pzmap(results{:});
    title(name)
    legend(legends)
    
    if toFile
        print(name, '-jpeg')
    end
    
    return
elseif isstruct(results)
    names = fieldnames(results);
    for i = 1:numel(names)
        figure
        temp = cell(1,2);
        temp{1} = results.(names{i}).vf.fit;
        temp{2} = results.(names{i}).arx.fit;
        
        temp{2} = d2c(temp{2});
        doComparison(sys.(names{i}).sys,temp,names{i},{'VF','ARX'});
    end
else
    bode(results*50*320)
    grid on
    compare(sys,results{:})
end