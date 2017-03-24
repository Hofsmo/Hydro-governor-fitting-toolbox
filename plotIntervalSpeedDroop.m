function plotIntervalSpeedDroop (f0, P0, R, std, N, fMin, fMax)
% FUNCTION PLOTSPEEDDROOP plots the total speed droop characeteristics
% Function that adds together the speed droop characteristics of many
% generators to get the total speed droop characteristics of the system
%
% INPUT:
% f0: The nominal frequency of the system.
% P0: Vector containing the set points of the generators
% R: Vector containing the droop of the generators
% fMin: The minimum allowed frequency of the system
% fMax: The maximum allowed frequency of the system

R = [R-1.645*std/sqrt(N), R, R+1.645*std/sqrt(N)];

figure
for i = 1:numel(R)
    PMax = floor((f0-fMin)/R(i) + P0);
    PMin = ceil((f0-fMax)/R(i) + P0);
    P = PMin:PMax; % Step size equal to one should make things simple
    f = f0 + R(i)*(P0-P);
    plot(P,f)
    if i == 1
        hold
    end
end
legend('Lower bound', 'Expectation', 'Upper bound')
grid on