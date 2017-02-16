function J = droop_jacobian(A,B)

a_g = 1/sum(B);
b_g = -sum(A)*a_g^2;

J = zeros(1,numel(A)+numel(B));

for i = 1:numel(A)
    J(i) = a_g;
end

for i = 1:numel(B)
    J(numel(A)+i) = b_g;
end