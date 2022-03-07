function [ y ] = kts2mps( x )
%[ y ] = kts2mps( x )
%kts2mps converts a speed from knots to metres per second
%   Inputs:
%   x = Airspeed [kts]
%   Outputs: 
%   y = Airspeed [m/s]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

y = x * 0.514444;


end

