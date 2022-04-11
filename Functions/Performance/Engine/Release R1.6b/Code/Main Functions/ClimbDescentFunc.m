function [Time, Range, Fuel, Data] = ClimbDescentFunc( GivenMass, Info, EngineData, Par)
%ClimbDescentFunc models the climb and descent segments of the mission
%profile
%
%[Time, Range, Fuel] = ClimbDescentFunc( GivenMass, Info, EngineData, ...
%     Mach_Mis_Climb, Mach_Mis_Descent, Mach_Div_Climb, Mach_Div_Descent, ...
%     CAS_Mis_ClimbLow, CAS_Mis_ClimbHigh, CAS_Mis_DescentLow, ...
%     CAS_Mis_DescentHigh, CAS_Div_ClimbLow, CAS_Div_ClimbHigh, ...
%     CAS_Div_DescentLow, CAS_Div_DescentHigh,  Alt_Cruise, Alt_Diversion,...
%     n, CD0_Clean, K_Clean, g, S )
%
%   Inputs:
%   GivenMass           = Known mass at start or end of climb/descent [kg]
%   Info                = Information flags about Part, Type & Method
%   EngineData          = Climb Engine Data
%   Mach_Mis_Climb      = Limit Mach (Mission Climb)
%   Mach_Mis_Descent    = Limit Mach (Mission Descent)
%   Mach_Div_Climb      = Limit Mach (Diversion Climb)
%   Mach_Div_Descent    = Limit Mach (Diversion Descent)
%   CAS_Mis_ClimbLow    = Limit CAS (Mission Climb below 10k ft)     [kts]
%   CAS_Mis_ClimbHigh   = Limit CAS (Mission Climb above 10k ft)     [kts]
%   CAS_Mis_DescentLow  = Limit CAS (Mission Descent below 10k ft)   [kts]
%   CAS_Mis_DescentHigh = Limit CAS (Mission Climb above 10k ft)     [kts]
%   CAS_Div_ClimbLow    = Limit CAS (Diversion Climb below 10k ft)   [kts]
%   CAS_Div_ClimbHigh   = Limit CAS (Diversion Climb above 10k ft)   [kts]
%   CAS_Div_DescentLow  = Limit CAS (Diversion Descent below 10k ft) [kts]
%   CAS_Div_DescentHigh = Limit CAS (Diversion Descent above 10k ft) [kts]
%   Alt_Cruise          = Cruise Altitude    [ft]
%   Alt_Diversion       = Diversion Altitude [ft]
%   n                   = Number of engines
%   CD0_Clean           = CD0 in clean configuration
%   K_Clean             = K   in clean configuration
%   g                   = Gravitational acceleration [m/s^2]
%   S                   = Wing reference area [m^2]
%
%   Outputs:
%   Time                = Duration of climb          [min]
%   Range               = Range covered during climb [nm]
%   Fuel                = Fuel burn during climb     [kg]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017
%%
if nargin < 1
    Par = AC_DP2001;
    % Par = AC_150C_twin;
    %     Mass                = 121314*0.453592;
    GivenMass           = 124634*0.453592;
    Info.Part           = 'Mission';%'Diversion';
    Info.Type           = 'Descent';%'Climb';
    Info.Method         = 'Forwards';%'Backwards';
    EngFileName         = Par.EngFileName;
    EngineData          = EngineGridFunc3( Info.Type, 1, EngFileName );
    % Update Kink Altitude values
    Par.Alt_kink_Mis_Climb = KinkFunc(Par.CAS_Mis_ClimbHigh, Par.Mach_Mis_Climb);
    Par.Alt_kink_Mis_Descent = KinkFunc(Par.CAS_Mis_DescentHigh, Par.Mach_Mis_Descent);
    Par.Alt_kink_Div_Climb = KinkFunc(Par.CAS_Div_ClimbHigh, Par.Mach_Div_Climb);
    Par.Alt_kink_Div_Descent = KinkFunc(Par.CAS_Div_DescentHigh, Par.Mach_Div_Descent);
    
end
%% Read aircraft parameters
g                      = Par.g;
S                      = Par.S;
n                      = Par.n;

Phase = 'Clean'; % Clean for Cruise and climb

CAS_Mis_ClimbLow       = Par.CAS_Mis_ClimbLow;
CAS_Mis_ClimbHigh      = Par.CAS_Mis_ClimbHigh;
CAS_Mis_DescentLow     = Par.CAS_Mis_DescentLow;
CAS_Mis_DescentHigh    = Par.CAS_Mis_DescentHigh;
CAS_Div_ClimbLow       = Par.CAS_Div_ClimbLow;
CAS_Div_ClimbHigh      = Par.CAS_Div_ClimbHigh;
CAS_Div_DescentLow     = Par.CAS_Div_DescentLow;
CAS_Div_DescentHigh    = Par.CAS_Div_DescentHigh;

Mach_Mis_Climb         = Par.Mach_Mis_Climb;
Mach_Mis_Descent       = Par.Mach_Mis_Descent;
Mach_Div_Climb         = Par.Mach_Div_Climb;
Mach_Div_Descent       = Par.Mach_Div_Descent;
Alt_Cruise             = Par.Alt_Cruise;
Alt_Diversion          = Par.Alt_Diversion;
hmin_ft                = Par.Alt_ClimbDescent_min; %1500
h1                     = Par.Alt_CAS_limits; %10000;
d_h                    = Par.Alt_delta_ClimbDescent; % Altitude intervals for each segment of Climb or Descent(delta_h) [ft]

Alt_kink_Mis_Climb   = Par.Alt_kink_Mis_Climb;    % Alt_kink for Climb [ft]
Alt_kink_Mis_Descent = Par.Alt_kink_Mis_Descent;  % Alt_kink for Decent [ft]
Alt_kink_Div_Climb   = Par.Alt_kink_Div_Climb;    % Alt_kink for Div Climb [ft]
Alt_kink_Div_Descent = Par.Alt_kink_Div_Descent;  % Alt_kink for Descent [ft]

%% Assign values to flags
Part   = Info.Part;
Type   = Info.Type;
Method = Info.Method;

%% Create new flag to assign limit CAS, Mach and Altitude
flag = [Part ':' Type];
switch (flag)
    case 'Mission:Climb'
        CAS_LowLimit  = CAS_Mis_ClimbLow;
        CAS_HighLimit = CAS_Mis_ClimbHigh;
        Mach_Limit    = Mach_Mis_Climb;
        hmax_ft       = Alt_Cruise;
        hkink_ft      = Alt_kink_Mis_Climb;
    case 'Mission:Descent'
        CAS_LowLimit  = CAS_Mis_DescentLow;
        CAS_HighLimit = CAS_Mis_DescentHigh;
        Mach_Limit    = Mach_Mis_Descent;
        hmax_ft       = Alt_Cruise;
        hkink_ft      = Alt_kink_Mis_Descent;
    case 'Diversion:Climb'
        CAS_LowLimit  = CAS_Div_ClimbLow;
        CAS_HighLimit = CAS_Div_ClimbHigh;
        Mach_Limit    = Mach_Div_Climb;
        hmax_ft       = Alt_Diversion;
        hkink_ft      = Alt_kink_Div_Climb;
    case 'Diversion:Descent'
        CAS_LowLimit  = CAS_Div_DescentLow;
        CAS_HighLimit = CAS_Div_DescentHigh;
        Mach_Limit    = Mach_Div_Descent;
        hmax_ft       = Alt_Diversion;
        hkink_ft      = Alt_kink_Div_Descent;
end

%% Calculate the kink altitude (limit CAS and limit Mach)
% hkink_ft = KinkFunc(CAS_HighLimit, Mach_Limit);
% Break range of altitude into increments

if hkink_ft > hmax_ft
    hkink_ft   = hmax_ft;
    %     hh1_ft     = linspace( hmin_ft, hkink_ft, 10);  % CAN TAKE 10 TO PARAMETER OBJECT
    
    hh1_ft     = hmin_ft:d_h:hkink_ft;
    h_ft       = hh1_ft;
else
    %     hh1_ft     = linspace( hmin_ft , hkink_ft, 100);
    %     hh2_ft     = linspace( hkink_ft, hmax_ft , 100);
    
    hh1_ft     = hmin_ft:d_h:hkink_ft;
    hh2_ft     = hkink_ft:d_h:hmax_ft;
    h_ft       = [hh1_ft,hh2_ft];
end
%% Set size of variables
ss=zeros(1,length(h_ft));
m             = ss;
W             = ss;
CL            = ss;
CD            = ss;
D             = ss;
ROC           = ss;
Error         = ss;
meanROC       = ss;
deltah_m      = ss;
deltat_sec    = ss;
deltat_min    = ss;
deltat_hr     = ss;
% TotalTime     = ss;
meanFF        = ss;
% TotalFuelBurn = ss;
FuelBurn      = ss;
meanTAS       = ss;
Range_m       = ss;
Range_nm      = ss;
%% Flip altitude increments if required
switch (Type)
    case 'Climb'
        switch (Method)
            case 'Forwards'  % No flip required
            case 'Backwards' % Flip is required
                h_ft = fliplr(h_ft);
        end
    case 'Descent'
        switch (Method)
            case 'Forwards'  % Flip is required
                h_ft = fliplr(h_ft);
            case 'Backwards' % No flip required
        end
end
%% Calculate the CAS and Mach at each altitude increment
h    = ft2m(h_ft);
h2   = hkink_ft;
CAS1 = (h_ft <= h1) .* CAS_LowLimit; % kts
M1   = CAS2Mach(h_ft, CAS1);
CAS2 = (h_ft > h1) .* (h_ft <= h2) .* CAS_HighLimit; % kts
M2   = CAS2Mach(h_ft, CAS2);
M3   = (h_ft > h1) .* (h_ft > h2) .*Mach_Limit;
CAS3 = Mach2CAS(h_ft, M3); % kts
CAS_kts = CAS1 + CAS2 + CAS3;
M       = M1 + M2 + M3;
%% Calculate the Acceleration Factors at each altitude
AF = AccelFactorFunc( h_ft, M, Mach_Limit);
%% Calculate the thrust and fuel flow at each altitude
[ FF_engine, T_engine ] = EngineInterpFunc( EngineData, h_ft, M, 0, ...
    'Unknown', 1, Par);
T_aircraft   = n .* T_engine;
FF_aircraft  = n .* FF_engine;
%% Calculate the dynamic pressure at each altitude
q = DynamicPressureFunc(h_ft, M);
%% Calculate the true airspeed at each altitude
[~, a, P, ~] = atmosisa(h);
CAS = kts2mps(CAS_kts);                         % Convert to m/s
% tic
% TAS = correctairspeed(CAS, a, P, 'CAS', 'TAS','TableLookup'); % Convert to TAS
TAS = correctairspeed(CAS, a, P, 'CAS', 'TAS','Equation'); % Convert to TAS
% TAS = correctairspeed1(CAS, a, P, 'CAS', 'TAS'); % Convert to TAS
% toc
%% Calculate the intial rate of climb, time, range and fuel burn
j                = 1;
m(j)             = GivenMass;
W(j)             = g * m(j);
CL(j)            = CLFunc(m(j), g, q(j), S);
CD(j)            = CDFunc(Phase, CL(j), M(j), Par);
D(j)             = q(j) * S * CD(j);
ROC(j)           = ROCFunc( T_aircraft(j), D(j), TAS(j), W(j), AF(j) ); % m/s

%% Calculate all other rate of climb, time, range and fuel burn
% Set the tolerance for the mass estimation error

tol = 1/length(h_ft); % [Kg] CAN TAKE THIS TO PARAMETER OBJECT

% Loop through all altitude increments
for j = 2:length(h_ft)
    % Initial mass estimate
    m(j) = m(j-1);
    % Initial error
    Error(j) = tol + 1;
    % Iterate until the error is less than the tolerance
    while Error(j) > tol
        % Calculate the rate of climb for second point
        W(j) = g * m(j);
        CL(j) = CLFunc(m(j), g, q(j), S);
        CD(j) = CDFunc(Phase, CL(j), M(j), Par);
        D(j) = q(j) * S * CD(j);
        ROC(j) = ROCFunc( T_aircraft(j), D(j), TAS(j), W(j), AF(j) ); % m/s
        %% Mean rate of climb for segment
        meanROC(j) = 0.5 * ( ROC(j) + ROC(j-1) );
        
        % Positive or negative rate of climb
        switch (Method)
            case 'Forwards'
                deltah_m(j) = h(j) - h(j-1);
            case 'Backwards'
                deltah_m(j) = h(j-1) - h(j);
        end
        % Calculate duration for segment
        deltat_sec(j) = deltah_m(j) / meanROC(j);
        deltat_min(j) = TimeFunc(deltat_sec(j), 'sec', 'min');
        deltat_hr(j) = TimeFunc(deltat_sec(j), 'sec', 'hr');
        % Calculate mean fuel flow for segment
        meanFF(j) = 0.5 * ( FF_aircraft(j) + FF_aircraft(j-1) );
        % Calculate fuel burn for segment
        FuelBurn(j) = meanFF(j) * deltat_hr(j);
        % Calculate mean true airspeed for segment
        meanTAS(j) = 0.5 * ( TAS(j) + TAS(j-1) );
        % Calculate range for segment
        Range_m(j) = meanTAS(j) * deltat_sec(j); % metres
        Range_nm(j) = m2nm(Range_m(j));          % nautical miles
        %% Calculate mass for next iteration
        switch (Method)
            case 'Forwards'
                Error(j) = abs( ( m(j-1) - FuelBurn(j) ) - m(j) );
                if Error(j) > tol
                    m(j) = m(j-1) - FuelBurn(j);
                end
            case 'Backwards'
                Error(j) = abs( ( m(j-1) + FuelBurn(j) ) - m(j) );
                if Error(j) > tol
                    m(j) = m(j-1) + FuelBurn(j);
                end
        end
    end
end


%% Total time
Time = sum(deltat_min);
%% Total range
Range = sum(Range_nm);
%% Total fuel burn
Fuel = sum(FuelBurn);

% Climb Details
if strcmp(flag,'Mission:Climb')
    Data.M = M;
    Data.CAS_kts        = CAS_kts;
    Data.TAS            = TAS;
    Data.ROC_fpm        = m2ft(ROC)*60;
    Data.meanROC_fpm    = m2ft(meanROC)*60;
    Data.h_ft           = h_ft;
    Data.Range_nm       = cumsum(Range_nm);
    Data.FuelBurn       = cumsum(FuelBurn);
    Data.time_min       = cumsum(deltat_min);
else
    Data =[];
end
end
