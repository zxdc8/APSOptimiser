function Par = BWB


% Call Parameters class
Par = Parameters;

% Change the required parameters
% (DP) mark parameters that can be used as design parameters

Par.g                      = 9.80665;   % Gravity [m/s^2]
Par.rho0                   = 1.225;     % Sea level density [kg/m^3]

% Design Parameters
Par.S                      = 500;       % Wing area [m^2] (DP)
Par.Range_req              = 7750;      % Required design range [nm] (DP)
Par.PLmax                  = 48000;     % Max payload [kg] (DP)
Par.MFC                    = 60000;     % Max Fuel capacity [kg] (DP)
Par.MTOM                   = 313000;    % Max Take Off Mass [kg] (DP)
Par.Airframe               = 200000;    % Operating Mass Empty [kg] (DP)
Par.PL_req                 = 48000;     % Design Payload [kg] (DP)

% Engine parmetars
Par.EngFileName            = 'HydrogenTurbojet'; % Aircraft type for engine data selection
Par.n                      = 3;         % Number of engines (DP)
Par.BPR                    = 12;         % By pass ratio
Par.TakeoffStaticThrust_lb = 120000;     % Take off thrust [lb] (DP)

% Aerodynamics data From typical values for large turboprop 
% Aerodynamics data
Par.CD0_Clean              = 0.015;     % Zero Lift Drag Coef [-] (DP)
Par.CD0_LD                 = 0.055;     % Zero Lift Drag Coef - flaps down [-] (DP)
Par.K_Clean                = 0.05 ;     % Induced Drag factor - clean [-] (DP)
Par.K_LD                   = Par.K_Clean ;     % Induced Drag factor - flaps down [-] (DP)
Par.CLmax_LD               = 2.5 ;      % Max Lift Coef - flaps down [-] (DP)
Par.DragRise               = 0;         % Flag to switch drag rise in the drag polar: 1 = Yes, 0 = No
Par.DragRise_Func          = 'DragRise_B777_AJenk'; % Name of Drag Rise Funcitn, e.g.'DragRise_B777_AJenk';

% Mission Parameters
Par.Time_Taxiout           = 7   ;      % Time Taxiout [min]
Par.Time_Approach          = 1   ;      % Time Approach [min]
Par.Time_ContCruise        = 0   ;     % Time Continuous Cruise [min]
Par.Time_Hold              = 90   ;     % Time Hold [min] 
Par.Time_Taxiin            = 5   ;      % Time Taxi-in[min]

Par.CAS_Hold               = 225.5 ;    % Speed CAS in Hold [kts]
Par.CAS_Mis_ClimbLow       = 250   ;    % Speed CAS in Climb 0 - 10000 ft [kts]
Par.CAS_Mis_ClimbHigh      = 300   ;    % Speed CAS in Climb above 10000 ft [kts]
Par.CAS_Mis_DescentLow     = 250   ;    % Speed CAS Descent - Low [kts]
Par.CAS_Mis_DescentHigh    = 300   ;    % Speed CAS Descent - High [kts]
Par.CAS_Div_ClimbLow       = 250   ;    % Speed CAS Div Climb - Low [kts]
Par.CAS_Div_ClimbHigh      = 300   ;    % Speed CAS Div Climb - High [kts]
Par.CAS_Div_DescentLow     = 250   ;    % Speed CAS Div Descent - Low [kts]
Par.CAS_Div_DescentHigh    = 300   ;    % Speed CAS Div Descent - High [kts]

Par.Mach_Cruise            = 0.7;      % Mach number cruise [-]
Par.Mach_Diversion         = Par.Mach_Cruise;      % Mach number Div cruise [-]
Par.Mach_Mis_Climb         = Par.Mach_Cruise-0.02;      % Mach number Climb high alt [-]
Par.Mach_Mis_Descent       = Par.Mach_Cruise-0.02;      % Mach number Decent High [-]
Par.Mach_Div_Climb         = Par.Mach_Cruise-0.02;      % Mach number Div Climb [-]
Par.Mach_Div_Descent       = Par.Mach_Cruise-0.02;      % Mach number Div Descent [-]

Par.Alt_Cruise             = 35000;     % Cruise Alt [ft]
Par.Alt_Diversion          = 25000;     % Div Cruise Alt [ft]
Par.Alt_Hold               = 1500;      % Hold Alt [ft]
Par.Alt_approach           = 1500;      % Approach Alt [ft]
Par.Alt_ClimbDescent_min   = 1500;      % Min Climb/Descent Alt [ft]
Par.Alt_CAS_limits         = 10000;     % Alt for CAS low/high limits [ft]

Par.Range_Diversion        = 200;       % Div range [nm]
Par.Range_Taxiout          = 0;         % Taxi-out range [nm]
Par.Range_Approach         = 0;         % Approach range [nm]
Par.Range_Taxiin           = 0;         % Taxi-in range [nm]
Par.Range_Takeoff          = 0;         % Take-off [nm]

Par.PercentagePolicy       = 0;         % Percentage cruise fuel reserve [%] - optional

% Computation parameters
Par.Tol_ContCruise         = 0.01;      % Computation Tolerance for criuse iterations
Par.Tol_Diversion          = 0.01;      % Computation Tolerance for Div iterations
Par.Tol_PercentPolicy      = 0.01;      % Computation Tolerance for reserve iterations
Par.dM_max                 = 0.2;       % Max allowed difference for Mach number in engine data
Par.dh_max                 = 5000;      % Max allowed difference for Alltitide in engine data

Par.interp_method          = 'spline';  % 'spline' or 'linear'

end

