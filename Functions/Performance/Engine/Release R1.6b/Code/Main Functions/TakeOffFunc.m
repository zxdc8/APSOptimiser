function [ Time, Range, Fuel ] = TakeOffFunc( Mass, Option, Par )
%TakeOffFunc models the take-off & intitial climb phase of the mission
%profile
%
%   Outputs:
%   Time      = Time of take-off      [min]
%   Range     = Range of take-off     [nm]
%   Fuel      = Fuel burn of take-off [kg]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    Mass   = 128168*0.453592; % kg
    Option = 'Overshoot';
    Par = AC_DP2001;
end

% Read Aircraft parameters from Par Object
n                      = Par.n;
BPR                    = Par.BPR;
TakeoffStaticThrust_lb = Par.TakeoffStaticThrust_lb;
Range_Takeoff          = Par.Range_Takeoff;

% Start calculations

Range = Range_Takeoff;
% Nominal Sea-Level Static Thrust [lb]
T_lb = TakeoffStaticThrust_lb;
% Time parameter directly from Airbus specification
timepar1 = 0.583;
% Convert mass to kg
Mass_lb = kg2lb(Mass);
% Formula for take-off time directly from Airbus Specification
Time = (timepar1 * Mass_lb) / (n * T_lb);
% Fuel parameters directly from Airbus Specification
fuelpar2 = 2.7795;
fuelpar3 = 2.3126;
switch (Option)
    case 'Take-off'
        SF = 1;
    case 'Overshoot'
        SF = 0.8;
end
% Formula for take-off fuel burn directly from Airbus Specification
% Fuel_lb = (fuelpar2 + (fuelpar3 / BPR)) * 0.001 * Mass_lb * SF;
%Fuel = lb2kg(Fuel_lb);
%Modified, Fuel as 8kg for Hydrogen as in Airbus Task Spec
Fuel = 8;  
end

