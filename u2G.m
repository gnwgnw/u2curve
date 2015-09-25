function [ phi, ro, X, Y, G ] = u2G( t, u )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

phi = cumtrapz(t, u);
ro = phi;
[X, Y] = curve_polar2decart(ro, phi);
G = complex(X, Y);

end

