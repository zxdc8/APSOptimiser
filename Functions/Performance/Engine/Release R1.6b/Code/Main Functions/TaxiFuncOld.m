function [ Time, Range, Fuel ] = TaxiFunc(Option, Par)
%TaxiFunc models the taxi phases of the mission profile 
%
% [ Time, Range, Fuel ] = TaxiFunc(Option, AC)
%
%   Inputs:
%   Option = 'Out' / 'In'
%   AC     = Aircraft data
%
%   Outputs:
%   Time   = Time of taxi      [min]
%   Range  = Range of taxi     [nm]
%   Fuel   = Fuel burn of taxi [kg]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*


if nargin < 1    
    Option = 'Out';
    Par = AC_DP2001;
end

% Read Aircraft parameters from Par Object
n                      = Par.n;
TakeoffStaticThrust_lb = Par.TakeoffStaticThrust_lb;
Time_Taxiout           = Par.Time_Taxiout;
Time_Taxiin            = Par.Time_Taxiin;
Range_Taxiout          = Par.Range_Taxiout;
Range_Taxiin           = Par.Range_Taxiin;

% Start calculations

switch (Option)
    case 'Out'
        % Scale factor used in calculation of fuel burn
        FuelSF = 1;
        Time   = Time_Taxiout;
        Range  = Range_Taxiout;
    case 'In'
        FuelSF = Time_Taxiin / (Time_Taxiout + 2.2);
        Time   = Time_Taxiin;
        Range  = Range_Taxiin;
end

% Nominal Sea-Level Static Thrust [lb]
T_lb = TakeoffStaticThrust_lb;
% Fuel parameters directly from Airbus Specification
par1 = 75.46;
par2 = 0.002250;
% Fuel formula directly from Airbus Specification
Fuel_lb = FuelSF * n * (par1 + (par2 * T_lb));
Fuel = lb2kg(Fuel_lb);

end

