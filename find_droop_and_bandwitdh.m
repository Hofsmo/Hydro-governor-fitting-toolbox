function [ R, bw ] = find_droop_and_bandwitdh(TF)
%UNTITLED function to find governor droop
%   Caclulate the droop and bandwodth for turbine governors
%
%   INPUT:
%       TF: Transfer function used to do the calculations
%       Sb: Machine base power
%       fb: Base frequency
%   OUTPUT:
%       R: The droop of the governor
%       R_pu: Droop in per unit
%       bw: The bandwidth of the governor
    gain = abs(dcgain(TF));
    R = 1/gain;
    bw = bandwidth(TF)/(2*pi);
end
