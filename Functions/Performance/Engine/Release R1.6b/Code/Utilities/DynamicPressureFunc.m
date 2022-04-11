function [ q ] = DynamicPressureFunc( h_ft, M )
%DynamicPressureFunc calculates the dynamic pressure
%   Inputs:
%   h_ft = Altitude [ft]
%   M    = Mach     [-]
%   Outputs:
%   q    = Dynamic pressure [Pa]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017


h = ft2m(h_ft);

[Temp0, a0, P0, rho0] = atmosisa(0);

[Temp, a, P, rho] = atmosisa(h);

TAS = a0 .* M .* (Temp./Temp0).^(0.5);

q = 0.5 .* rho .* TAS.^2;

end

