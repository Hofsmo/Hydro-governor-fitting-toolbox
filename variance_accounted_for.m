function [vaf_pred, vaf_sim] = variance_accounted_for(model, data)
%VARIANCE_ACCOUNTED_FOR Calculate the variance accounted for
%   INPUT:
%       model: estimated model
%       data: data for verification
%   OPTUPUT:
%       vaf_pred: Variance accounted for using predicted data
%       vaf_sim: Variance accounted for using simulated data

    y = data.OutputData;
    y_2 = norm(y);
    
    y_sim= compare(data, model);
    vaf_sim = max([0, (1 - norm(y-y_sim.OutputData)/y_2)*100]);
    
    y_pred = predict(model, data, 1);
    vaf_pred = max([0, (1 - norm(y-y_pred.OutputData)/y_2)*100]);

end

