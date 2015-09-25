function [ X, Y ] = curve_polar2decart( ro, phi )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

X = ro .* cos(phi);
Y = ro .* sin(phi);

end

