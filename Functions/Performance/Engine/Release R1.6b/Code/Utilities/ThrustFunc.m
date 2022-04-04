function T_engine = ThrustFunc( Mass, h_ft, Mach, Par, Phase)
%ThrustFunc calculates the thrust required to balance drag
%
% T_eng = ThrustFunc( Mass, h_ft, Mach, AC )
%
%   Inputs:
%   Mass  = Mass of aircraft [kg]
%   h_ft  = Altitude         [ft]
%   Mach  = Mach             [-]
%   AC    = Aircraft data
%
%   Outputs:
%   T_eng = Thrust of single engine [N]
%
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    Mass = 205000;
    h_ft = 35000;
    Mach = 0.82;
    Par = AC_DP2001;
    Phase = 'Clean';
end
g = Par.g;
n = Par.n;
S = Par.S;

q     = DynamicPressureFunc(h_ft, Mach);
CL    = CLFunc(Mass, g, q, S);
CD    = CDFunc(Phase, CL, Mach, Par);
D     = q * S * CD;
T_aircraft  = D;
T_engine = T_aircraft / n;

end

