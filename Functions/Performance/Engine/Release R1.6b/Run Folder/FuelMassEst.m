function [Mf, Vf] = FuelMassEst(M,Alt,S,CD0,k)

%% Run Design Set
%This file is based on AVDASI 4 RunDesignSet - with output of Wf - fuel
%weight, and Vf - Volume of fuel tanks

%It accepts the following Opt variables Mach number, M, Cruise Altitude,
%Alt, Wing Surface Area, S, Zero Lift Drag Coef, CD0, Induced Drag factor,
%k

%% Initialise aircraft parameters

clear; clc
disp(' ')
disp('        ******** Aircraft Performance Tool ********');
disp('        ******** Run Design Mission Case ********')
disp(['                  ', datestr(clock)]);
disp(' ')

% Read Aircraft data from a re-defined file, e.g. BWB for the blended wing
% body design
ParFunc = 'BWB';
Par     = eval(ParFunc);  % Set parameters in the "Par" object, 
                          % Default values are set in the ParFunc

disp(['... Aircraft parameters are set, based on ', ParFunc, ' data file'])
disp(' ')


%% Calculate the mass, fuel and range for a set of missions


Par.Mach_Cruise            = M;      % Mach number cruise [-]
Par.Alt_Cruise             = Alt;     % Cruise Alt [ft]
Par.S                      = S;       % Wing area [m^2] (DP)
Par.CD0_Clean              = CD0;     % Zero Lift Drag Coef [-] (DP)
Par.K_Clean                = k;     % Induced Drag factor - clean [-] (DP)




% Extra parameters that are set but might be modified - Look at Weight
Par.Range_req              = 7750;      % Required design range [nm] (DP)
Par.PLmax                  = 48000;     % Max payload [kg] (DP)
Par.MFC                    = 60000;     % Max Fuel capacity [kg] (DP)
Par.MTOM                   = 313000;    % Max Take Off Mass [kg] (DP)
Par.Airframe               = 205000;    % Operating Mass Empty [kg] (DP)
Par.PL_req                 = 48000;     % Design Payload [kg] (DP)

% call function FindDesignPoint to calculate mission properties
dp1 = FindDesignPoint(Par);
    

%% Output results

%Fuel Consumption
Mf = dp1.TotalFuel;

%Fuel Volume required - NOTE: 20% space for tanks 
rholh2 = 71; %[kg/m3]


Vf = (Mf*1.2)/rholh2;%[m3]

end





