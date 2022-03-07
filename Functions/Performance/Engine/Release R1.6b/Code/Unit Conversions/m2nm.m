function [ y ] = m2nm( x )
%m2nm converts a distance in metres to nautical miles
%   Input:
%   x = Distance [m]
%   Output:
%   y = Distance [nm]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

y = x ./ 1852; 

end

