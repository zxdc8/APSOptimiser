%
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

classdef Parameters
    % Parameters sets all parameters for Aircraft, engines, mision and
    % computations
    
    properties  % Default aircraft data
        
        g                      = 9.80665;   % Gravity [m/s^2]
        rho0                   = 1.225;     % Sea level density [kg/m^3]
        
        % Design Parameters
        
        PL_req                 = 29050;     % Required payload mass [kg]
        Range_req              =  5000;     % Required design range [nm]
        S                      = 376.4;     % Wing area [m^2]
        PLmax                  = 45000;     % Max payload [kg]
        MFC                    = 80000;     % Max Fuel capacity [kg]
        MTOM                   = 230000;    % Max Take Off Mass [kg]
        Airframe               = 130000;    % Operating Mass Empty [kg]
        SF = 3;
        
        % Engine parmetars
        
        EngFileName            = 'UBB65Data'; % Aircraft type for engine data selection
        n                      = 2;         % Number of engines (DP)
        BPR                    = 5;         % By pass ratio
        TakeoffStaticThrust_lb = 64996;     % Take off thrust [lb] (DP)
        M_ext                  = [];        % Extend Mach numner range to M_ext, change to somthing like 0.1 if needed
        interp_method          = 'linear';  % 'spline' or 'linear', interpolation method for engie data
        
        % Aerodynamics data
        
        CD0_Clean              = 0.015;     % Zero Lift Drag Coef [-] (DP)
        CD0_LD                 = 0.055;     % Zero Lift Drag Coef - flaps down [-] (DP)
        K_Clean                = 0.05 ;     % Induced Drag factor - clean [-] (DP)
        K_LD                   = 0.05 ;     % Induced Drag factor - flaps down [-] (DP)
        CLmax_LD               = 2.5 ;      % Max Lift Coef - flaps down [-] (DP)
        DragRise               = 0;         % Flag to switch drag rise in the drag polar: 1 = Yes, 0 = No
        DragRise_Func          = 'DragRise_?'; % Name of Drag Rise Funcitn, e.g.'DragRise_B777_AJenk';
        
        % Mission Parameters
        
        Time_Taxiout           = 7   ;      % Time Taxiout [min]
        Time_Approach          = 5   ;      % Time Approach [min]
        Time_ContCruise        = 45   ;     % Time Continuous Cruise [min]
        Time_Hold              = 30   ;     % Time Hold [min]
        Time_Taxiin            = 7   ;      % Time Taxi-in[min]
        
        CAS_Hold               = 210   ;    % Speed CAS in Hold [kts]
        CAS_Mis_ClimbLow       = 250   ;    % Speed CAS in Climb 0 - 10000 ft [kts]
        CAS_Mis_ClimbHigh      = 300   ;    % Speed CAS in Climb above 10000 ft [kts]
        CAS_Mis_DescentLow     = 250   ;    % Speed CAS Descent - Low [kts]
        CAS_Mis_DescentHigh    = 300   ;    % Speed CAS Descent - High [kts]
        CAS_Div_ClimbLow       = 250   ;    % Speed CAS Div Climb - Low [kts]
        CAS_Div_ClimbHigh      = 300   ;    % Speed CAS Div Climb - High [kts]
        CAS_Div_DescentLow     = 250   ;    % Speed CAS Div Descent - Low [kts]
        CAS_Div_DescentHigh    = 300   ;    % Speed CAS Div Descent - High [kts]
        
        Mach_Cruise            = 0.82;      % Mach number cruise [-]
        Mach_Diversion         = 0.60;      % Mach number Div cruise [-]
        Mach_Mis_Climb         = 0.80;      % Mach number Climb high alt [-]
        Mach_Mis_Descent       = 0.80;      % Mach number Decent High [-]
        Mach_Div_Climb         = 0.60;      % Mach number Div Climb [-]
        Mach_Div_Descent       = 0.60;      % Mach number Div Descent [-]
        
        Alt_Cruise             = 35000;     % Cruise Alt [ft]
        Alt_Diversion          = 20000;     % Div Cruise Alt [ft]
        Alt_Hold               = 1500;      % Hold Alt [ft]
        Alt_approach           = 1500;      % Approach Alt [ft]
        Alt_ClimbDescent_min   = 1500;      % Min Climb/Descent Alt [ft]
        Alt_CAS_limits         = 10000;     % Alt for CAS low/high limits [ft]
        Alt_delta_ClimbDescent = 1000;       % Altitude intervals for each segment of Climb or Descent(delta_h) [ft]
        
        Range_Diversion        = 200;       % Div range [nm]
        Range_Taxiout          = 0;         % Taxi-out range [nm]
        Range_Approach         = 0;         % Approach range [nm]
        Range_Taxiin           = 0;         % Taxi-in range [nm]
        Range_Takeoff          = 0;         % Take-off [nm]
        
        PercentagePolicy       = 0;         % Percentage cruise fuel reserve [%] - optional
        
        % Computation parameters
        
        Tol_ContCruise         = 0.01;      % Computation Tolerance for criuse iterations
        Tol_Diversion          = 0.01;      % Computation Tolerance for Div iterations
        Tol_PercentPolicy      = 0.01;      % Computation Tolerance for reserve iterations
        dM_max                 = 0.2;       % Max allowed difference for Mach number in engine data
        dh_max                 = 5000;      % Max allowed difference for Alltitide in engine data
        
        display                = 0;         % display additional messages in the display.txt file
        NP_MTOM                = 4;         % Number of point for the MTOM curve for the Payload Range Diagram
        NP_MFC                 = 4;         % Number of point for the MFC curve for the Payload Range Diagram
    end
    
    properties
        
        Alt_kink_Mis_Climb     = 30000; % Alt_kink for Climb [ft]
        Alt_kink_Mis_Descent   = 30000; % Alt_kink for Decent [ft]
        Alt_kink_Div_Climb     = 1500; % Alt_kink for Div Climb [ft]
        Alt_kink_Div_Descent   = 1500; % Alt_kink for Descent [ft]
    end
    
    methods
        
    end
    
end
