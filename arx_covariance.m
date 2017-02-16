function [COV] = arx_covariance(model, data)
%ARX_COVARIANCE Summary of this function goes here
%   INPUT:
%       model: estimated ARX-model
%   OUTPUT:
%       COV: The covariance matrix

    [psi, y_hat] = arx_regression_vector(model, data);
    y = data.OutputData;
    e = y - y_hat;
    N = numel(y);
    lambda = 1/N*sum(e.^2);
    
    tmp = zeros(size(psi,1));
    for i = 1:N        
        tmp = tmp + psi(:,i)*psi(:,i)';
    end
        
    COV = lambda*inv(tmp);
end

