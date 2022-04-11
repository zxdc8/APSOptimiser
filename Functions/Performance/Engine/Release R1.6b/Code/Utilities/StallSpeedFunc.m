function Vstall = StallSpeedFunc( m, rho0, g, S, CLmax_LD )
%StallSpeedFunc calculates the stall speed at sea level
%
% Vstall = StallSpeedFunc( m, rho0, g, S, CLmax_LD )
%
%   Inputs:
%   m  = Mass                        [kg]
%   rho0 = Density at sea-level      [kg/m^3]
%   g = Gravitational acceleration   [m/s^2]
%   S = Wing reference area          [m^2]
%   CLmax = Maximum lift coefficient [-]
%
%   Output:
%   Vstall = Stall speed at sea level [m/s]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    m        = 160000;
    rho0     = 1.225;
    g        = 9.81;
    S        = 376.4;
    CLmax_LD = 2.5;
end

Vstall = sqrt( (2 * m * g) / (rho0 * S * CLmax_LD));

end

