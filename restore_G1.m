function [ G1 ] = restore_G1( G2, S )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

G1 = (G2 .* S(1,2) .* S(2,1)) ./ (1 - G2 .* S(2,2)) + S(1,1);

end