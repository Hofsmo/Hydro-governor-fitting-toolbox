function jacobian = bandwidth_jacobian(model)
%BANDWIDTH_JACOBIAN calculate the jacobian for the bandwidth
% INPUT:
%   model: Turbine governor model identified using ARX or ARMAX
% OUTPUT:
%   jacobian: The jacobian of the bandwidth

P = [model.A(2:end), model.B];
na = numel(model.A);

% Calulate the bandwidth of the model
bw = bandwidth(model);

jacobian = zeros(1,numel(P));

% Calculate the differention step size
h = nuderst(P);

k = 1;

for i = 2:size(jacobian, 2)
    if i <= na
        tmp_str = 'A';
        k = i;
    else
        tmp_str = 'B';
        k = i - na; 
    end
    
    temp = model; 
    temp.(tmp_str)(k) = temp.(tmp_str)(k) + h(i);
    jacobian(k) = (bandwidth(temp)-bw)/h(i);
end
