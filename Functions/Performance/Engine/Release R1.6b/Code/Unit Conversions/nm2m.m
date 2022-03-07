function [ y ] = nm2m( x )
%nm2m converts a distance in nautical miles to metres
%   Input:
%   x = Distance [nm]
%   Output:
%   y = Distance [m]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

y = x .* 1852; 

end

