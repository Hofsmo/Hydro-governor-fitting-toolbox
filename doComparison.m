function doComparison(sys, results, name, legends, toLaTeX, figureSize)
% DOCOMPARISON compares fitted models with measurements
% doComparison compares different fitted models with measurements using the
% compare function. It also plots the bode plot and a plot showing the
% poles and zeros.
% INPUT:
%   sys: Input and output measurements stored in an iddata object
%   results: Struct containing the fitted models
%   name: Name of the model being fitted
%   legends: Show legends
%   toLaTeX: If the plots should be saved as LaTeX figure

if nargin < 6
    figureSize = '0.5\textwidth';
end
if nargin < 5
    toLaTeX = false;
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
    
    if toLaTeX
        saveLaTeX ('Bode', name,figureSize)
    end
    
    compare(sys,results{:})
    legend(legends)
    
    if toLaTeX
        saveLaTeX ('compare', name,figureSize)
    end
    figure
    pzmap(results{:});
    title(name)
    legend(legends)
    
    if toLaTeX
        saveLaTeX ('pzmap', name,figureSize)
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
    if toLaTeX
        saveLaTeX ('Bode', name,figureSize)
    end
    grid on
    compare(sys,results{:})
end

function saveLaTeX (string, name,figureSize)
% SAVELATEX get figure handle and save to latex
% Private function to save LaTeX figures
% INPUT:
%   string: String specifying what type of plot this is
%   name: Name of the model
h = gcf;
matlab2tikz('figurehandle',h, 'filename', sprintf('%s_%s.tikz',name,string));