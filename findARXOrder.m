function models = findARXOrder(sys,NN,tol,opt)
% FINDARXORDER function to find best ARX model order
%
% Input:
%   sys: System to be fitted as ann iddata object
%   NN: Array of model orders to test
%   tol: Accepted deviation from best fit in percentage
% Output:
%   models: Struct containing the model with the best fit and the one with
%   the lowest order within the tolerance limit

if nargin < 3
    tol = 1;
end
if nargin < 4
    opt = arxOptions('Focus','stability');
end

models.best.tf = [];
models.lowest.tf = []; 
models.best.fit = 0;
models.lowest.fit = 0;

for i = 1:size(NN,1)
    temp=arx(sys,NN(i,:),opt);
    [~,fit,~] = compare(sys,temp);
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