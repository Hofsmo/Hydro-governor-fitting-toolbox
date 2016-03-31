function [fit, responses] = doComparison(sys, results, name, legends, toLaTeX, figureWidth)
% DOCOMPARISON compares fitted models with measurements
% doComparison compares different fitted models with measurements using the
% compare function. It also plots the bode plot and a plot showing the
% poles and zeros.
% INPUT:
%   sys: Input and output measurements stored in an iddata object
%   results: Cell array containing the transfer functions of the fitted
%   model
%   name: Name of the model being fitted
%   legends: Array containing legend entries
%   toLaTeX: If the plots should be saved as LaTeX figure
%   figureWidth: The width of the figure. The default is 0.5\textwidth
if nargin < 6
    figureWidth = '0.5\textwidth';
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
bode(results{:})
legend(legends)
grid on
title (name)

if toLaTeX
    saveLaTeX ('Bode', name,figureWidth)
end

[y,fit] = compare(sys,results{:});
responses = {iddata(sys.OutputData,[], sys.Ts) ,y{:}};

temp = cell(1,numel(legends)+1);
temp{1} = 'Measured response';
for i = 1:numel(legends)
    temp{i+1} = sprintf('%s \t \t %4.2f%%',legends{i},fit{i});
end

figure
plot(responses{:})
legend(temp)
title (name)

if toLaTeX
    saveLaTeX ('compare', name,figureWidth)
end
figure
for i = 1:numel(results)
    if isdt(results{i})
        results{i} = d2c(results{i});
    end
end
pzmap(results{:});
title(name)
legend(legends)

if toLaTeX
    saveLaTeX ('pzmap', name,figureWidth)
end
    
function saveLaTeX (string, name,figureWidth)
% SAVELATEX get figure handle and save to latex
% Private function to save LaTeX figures
% INPUT:
%   string: String specifying what type of plot this is
%   name: Name of the model
%   figureWidth: The widht of the figure
matlab2tikz('filename', sprintf('%s_%s.tikz',name,string),...
    'width',figureWidth);