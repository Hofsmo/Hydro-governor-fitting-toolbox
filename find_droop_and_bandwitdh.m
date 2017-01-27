function [ R, Rpu, bw ] = find_droop_and_bandwitdh(tf, Sb, fb)
%UNTITLED function to find governor droop
%   Caclulate the droop and bandwodth for turbine governors
%
%   INPUT:
%       tf: Transfer function used to do the calculations
%       Sb: Machine base power
%       fb: Base frequency
%   OUTPUT:
%       R: The droop of the governor
%       R_pu: Droop in per unit
%       bw: The bandwidth of the governor
    gain = abs(tf.Numerator{1}(end)/tf.Denominator{1}(end));
    R = 1/gain;
    Rpu = R/f_base*Sb;
    bw = bandwidth(tf)/(2*pi);
end
