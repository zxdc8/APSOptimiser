function CL = CLFunc( m, g, q, S )
%CLFunc calculates the lift coefficient
%
%CL = CLFunc( m, q, S )
%
%   Inputs:
%   m = Mass [kg]
%   g = Gravitational acceleration [m/s^2]
%   q = Dynamic pressure [Pa]
%   S = Wing reference area [m^2]
%
%   Outputs:
%   CL = Lift coefficient [-]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

CL = (m .* g) ./ (q .* S);

end

