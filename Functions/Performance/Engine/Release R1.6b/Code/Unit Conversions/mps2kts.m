function [ y ] = mps2kts( x )
%[ y ] = mps2kts( x )
%mps2kts converts a speed from metres per second to knots
%   Inputs:
%   x = Airspeed [m/s]
%   Outputs: 
%   y = Airspeed [kts]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

y = x .* 1.94384;


end

