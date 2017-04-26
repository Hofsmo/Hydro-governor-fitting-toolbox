function [models, indicators] = findARMAXOrder(sys1,sys2,NN,tol,opt)
% FINDARXORDER function to find best ARX model order
%
% Input:
%   sys: System to be fitted as ann iddata object
%   NN: Array of model orders to test
%   tol: Accepted deviation from best fit in percentage
% Output:
%   models: Struct containing the model with the best fit and the one with
%   the lowest order within the tolerance limit
%   inditcators: Information criterion indicators.

if nargin < 4
    tol = 1;
end
if nargin < 5
    opt = arxOptions('Focus','prediction');
end

models.best.tf = [];
models.lowest.tf = []; 
models.best.fit = 0;
models.lowest.fit = 0;

indicators = [NN(:,1:3),zeros(size(NN,1),4)];

for i = 1:size(NN,1)
    temp=armax(sys1,NN(i,:),opt);
    indicators(i,4) = temp.Report.fit.AIC;
    indicators(i,5) = temp.Report.fit.BIC;
    indicators(i,6) = temp.Report.fit.FPE;
    [~,fit,~] = compare(sys2,temp);
    indicators(i,7) = fit;
    [vaf_pred, vaf_sim] = variance_accounted_for(temp, sys2);
    indicators(i,8) = vaf_pred;
    indicators(i,9) = vaf_sim;
    fit = vaf_pred;
    if fit > models.best.fit || ~models.best.fit
        models.best.fit = fit;
        models.best.tf = temp;
        if isempty(models.lowest.tf)
            models.lowest = models.best;
        elseif abs(fit-models.lowest.fit)>tol
            models.lowest = models.best;
        end
    elseif abs(fit-models.best.fit)<tol &&...
            NN(i,1)<numel(models.lowest.tf.a)-1
        models.lowest.tf = temp;
        models.lowest.fit = fit;
    end
end