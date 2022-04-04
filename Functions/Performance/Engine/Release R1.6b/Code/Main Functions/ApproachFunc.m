function [Time, Range, Fuel] = ApproachFunc( Mass, EngineData_ap, Par)
% [Time, Range, Fuel] = ApproachFunc( Mass, EngineData_ap, Par)
% ApproachFunc models the approach phase of the mission profile
%
%    Inputs:
%    Mass  
%    EngineData_ap  
%    Par
% 
%   Outputs:
%   Time                = Duration of approach          [min]
%   Range               = Range covered during approach [nm]
%   Fuel                = Fuel burn during approach     [kg]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017
if nargin < 1
    Par = AC_DP2001;
%     Par = AC_150C_twin;
    EngineData     = GriddedEngineData(Par);
    EngineData_ap  = EngineData.Approach;
    Mass           = 121314*0.453592;
end

% Read Aircraft parameters from Par Object
n              = Par.n;
S              = Par.S;
g              = Par.g;
CLmax_LD       = Par.CLmax_LD;
Range_Approach = Par.Range_Approach;
Time_Approach  = Par.Time_Approach;

Phase = 'LD'; % LD for approach
h_ft           = Par.Alt_approach;
h              = ft2m(h_ft);
[~, ~, ~, rho] = atmosisa(h);

% Stall speed in landing configuration [m/s]
Vs_landing = StallSpeedFunc( Mass, rho, g, S, CLmax_LD );
% Stall speed in approach configuration [m/s]
Vs_approach   = 1.1 * Vs_landing;
% Approach speed
V_approach    = 1.3 * Vs_approach;
% Lift coefficient in approach
CL = CLmax_LD .* Vs_landing.^2 ./ V_approach.^2;
% Mach in approach
Mach = TAS2Mach(0, V_approach);
% Engine thrust
T_engine = ThrustFunc( Mass, h_ft, Mach, Par, Phase);
% Fuel flow [kh/hr]
[ FF_engine, ~ ] = EngineInterpFunc( EngineData_ap, h_ft, Mach, T_engine, 'Known', 1, Par );
FF_aircraft = FF_engine .* n;
% Time 
Time = Time_Approach; % min
Time_hr = TimeFunc(Time, 'min', 'hr'); % hr
% Fuel [kg]
Fuel = FF_aircraft .* Time_hr;
% Range
Range = Range_Approach;

end

