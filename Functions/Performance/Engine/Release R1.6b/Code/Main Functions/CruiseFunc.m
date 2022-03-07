function [ Time, Range, Fuel ] = CruiseFunc( flag, MassStart, ...
    MassEnd, Range_nm, FlightTime, EngineData_Cruise, ...
    EngineData_Diversion, EngineData_Hold, Par)
%[ Time, Range, Fuel ] = CruiseFunc( flag, MassStart, ...
%     MassEnd, Range_nm, FlightTime, EngineData_Cruise, ...
%     EngineData_Diversion, EngineData_Hold, Par)
%
% CruisingFunc models all phases of cruise in the mission profile: Mission,
% Diversion, ContinuedCruise, PercentPolciy & Hold
%
%
%     Inputs:
%     flag                 = Mission/Diversion/ContCruise/PercPolicy/Hold
%
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*,
% University of Bristol 2017

if nargin < 1
    Par = AC_DP2001;
    EngFileName = Par.EngFileName;
    flag                 = 'Mission';%'Diversion';%'Continued';%'Hold';%'PercentPolicy';
    MassStart            = 141653*0.453592;
    MassEnd              = 128629*0.453592;
    Range_nm             = 0; %80;
    FlightTime           = 0;
    EngineData_Cruise    = EngineGridFunc3( 'Cruise', 1, EngFileName );
    EngineData_Diversion = EngineGridFunc3( 'Diversion', 1, EngFileName );
    EngineData_Hold      = EngineGridFunc3( 'Hold', 1, EngFileName );
end

% Set parameters
Mach_Cruise          = Par.Mach_Cruise;
Mach_Diversion       = Par.Mach_Diversion;
CAS_Hold             = Par.CAS_Hold;
Alt_Cruise           = Par.Alt_Cruise;
Alt_Diversion        = Par.Alt_Diversion;
Alt_Hold             = Par.Alt_Hold;
PercentagePolicy     = Par.PercentagePolicy;
Time_ContCruise      = Par.Time_ContCruise;
Time_Hold            = Par.Time_Hold;
n                    = Par.n;

Phase = 'Clean'; % Clean for Cruise and climb

switch (flag)
    case {'Mission', 'Continued', 'PercentPolicy'}
        h_ft       = Alt_Cruise;
        Mach       = Mach_Cruise;
        EngineData = EngineData_Cruise;
    case 'Diversion'
        h_ft       = Alt_Diversion;
        Mach       = Mach_Diversion;
        EngineData = EngineData_Diversion;
    case 'Hold'
        h_ft       = Alt_Hold;
        CAS_kts    = CAS_Hold;
        EngineData = EngineData_Hold;
end

h                      = ft2m(h_ft);
[Temp_0, a_0, ~,   ~ ] = atmosisa(0); % MATLAB function
[Temp_h, a_h, P_h, ~ ] = atmosisa(h); % MATLAB function

switch (flag)
    case {'Mission', 'Diversion', 'Continued', 'PercentPolicy'}
        TAS  = a_0 .* Mach .* (Temp_h./Temp_0).^(0.5);
    case 'Hold'
        CAS  = kts2mps(CAS_kts);
        %         TAS  = correctairspeed(CAS, a_h, P_h, 'CAS', 'TAS'); % MATLAB function
        % TAS = correctairspeed(CAS, a_h, P_h, 'CAS', 'TAS','TableLookup'); % Convert to TAS
        TAS = correctairspeed(CAS, a_h, P_h, 'CAS', 'TAS','Equation'); % Convert to TAS
%         TAS = correctairspeed1(CAS, a_h, P_h, 'CAS', 'TAS'); % Convert to TAS
        Mach = CAS2Mach(h_ft, CAS_kts);
end

switch (flag)
    case {'Mission', 'PercentPolicy'}
        MassMiddle  = 0.5 * (MassStart + MassEnd);
        T_engine    = ThrustFunc( MassMiddle, h_ft, Mach, Par, Phase);
        [ FF_engine, ~ ] = EngineInterpFunc( EngineData, h_ft, Mach, T_engine, 'Known', 1 , Par);
        FF_aircraft = n * FF_engine;
        switch (flag)
            case 'Mission'
                Fuel        = MassStart - MassEnd;
                Time_hr     = Fuel / FF_aircraft;
                Time_sec    = TimeFunc(Time_hr, 'hr', 'sec');
                Time        = TimeFunc(Time_hr, 'hr', 'min');
                Range_m     = TAS * Time_sec;
                Range       = m2nm(Range_m);
            case 'PercentPolicy'
                Time        = FlightTime * PercentagePolicy / 100;
                Time_hr     = TimeFunc(Time, 'min', 'hr');
                Fuel        = FF_aircraft * Time_hr;
                Time_sec    = TimeFunc(Time, 'min', 'sec');
                Range_m     = TAS * Time_sec;
                Range       = m2nm(Range_m);
        end
    case 'Diversion'
        Range        = Range_nm;
        Range_m      = nm2m(Range);
        Time_sec     = Range_m / TAS;
        Time         = TimeFunc(Time_sec, 'sec', 'min');
        Time_hr      = TimeFunc(Time, 'min', 'hr');
        Fuel  = 0; % Initial under-estimate
        tol   = 0.05;
        Error = tol + 1;
        while Error > tol
            MassMiddle    = MassEnd + 0.5 * Fuel;
            T_engine      = ThrustFunc( MassMiddle, h_ft, Mach, Par, Phase);
            [ FF_engine, ~ ] = EngineInterpFunc( EngineData, h_ft, Mach, T_engine, 'Known', 1, Par);
            
            FF_aircraft   = n * FF_engine;
            FuelNew       = FF_aircraft * Time_hr;
            Error         = abs( Fuel - FuelNew );
            Fuel          = FuelNew;
        end
        
    case {'Continued', 'Hold'}
        switch (flag)
            case 'Continued'
                Time = Time_ContCruise;
                MassMiddle = MassStart; % Initial estimate
            case 'Hold'
                Time = Time_Hold;
                MassMiddle = MassEnd; % Initial estimate
        end
        Time_sec = TimeFunc(Time, 'min', 'sec');
        Time_hr  = TimeFunc(Time, 'min', 'hr');
        Range_m  = TAS * Time_sec;
        Range    = m2nm(Range_m);
        
        tol        = 0.05;      % Tolerance
        Error      = tol + 1;   % Initial Error
        
        
        while Error > tol
            T_engine = ThrustFunc( MassMiddle, h_ft, Mach, Par, Phase);
            [ FF_engine, ~ ] = EngineInterpFunc( EngineData, h_ft, Mach, T_engine, 'Known', 1 , Par);
            FF_aircraft = FF_engine .* n;
            Fuel        = FF_aircraft * Time_hr;
            switch (flag)
                case 'Continued'
                    MassEnd = MassStart - Fuel;
                case 'Hold'
                    MassStart = MassEnd + Fuel;
            end
            MassNewMiddle = 0.5 * ( MassStart + MassEnd );
            Error         = abs( MassNewMiddle - MassMiddle );
            MassMiddle    = MassNewMiddle;
        end
end