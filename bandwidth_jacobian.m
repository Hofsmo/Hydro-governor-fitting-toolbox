function jacobian = bandwidth_jacobian(model)
%BANDWIDTH_JACOBIAN calculate the jacobian for the bandwidth
% INPUT:
%   model: Turbine governor model identified using ARX or ARMAX
% OUTPUT:
%   jacobian: The jacobian of the bandwidth

P = [model.A(2:end), model.B];
na = model.A(2:end);

% Calulate the bandwidth of the model
bw = bandwidth(model);

jacobian = zeros(1,numel(P));

% Calculate the differention step size
h = nuderst(P);

for i = 1:size(jacobian, 2)
    if i < na
        tmp_str = 'A';
    else
        tmp_str = 'B';
    end
    
    temp = model.(tmp_str)(i); 
    temp.(tmp_str)(i) = temp.(tmp_str)(i) + h(i);
    jacobian(i) = (bandwidth(temp)-bw)/h(i);
end
