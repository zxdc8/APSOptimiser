function [diff, TotalFuel, Block, Mission] = MissionProfileFunc(Payload, flag, EngineData, TOM , Par)
%MissionProfile2 models a single point on the payload-range diagram
%
%[Fuel_diff, TotalFuel, Block, Mission] = MissionProfile(Payload, MTOM, MFC, flag, EngineData)
%
%   Inputs:
%   Payload    = Mass of the payload carried [kg]
%   flag       = Defines solution method     [-]
%   EngineData = Structure of tabulated data [-]
%
%   Outputs:
%   Fuel_diff  = MFC - TotalFuel
%   TotalFuel  = Mass of total fuel carried  [kg]
%   Block      = Structure of block time, range & fuel
%   Mission    = Structure of time, range, fuel & mass
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol

% tic
%% Default inputs
if nargin < 1
    Par = AC_DP2001;
    Payload = 1000;
    flag    = 'MTOM';
    EngineData = GriddedEngineData(Par);
end
%% Throw error if 'Design' case and TOM not input
if nargin < 4
    switch flag
        case 'Design'
            error('This is a Design case, TOM value is missing ... [] = MissionProfileFunc(Payload, flag, EngineData, TOM )');
        case {'MFC','MTOM'}
            TOM = 0;
            Par = AC_DP2001;
            EngineData = GriddedEngineData(Par);
    end
end
% filename = 'display.txt';
% fid = fopen(filename,'w');
% fprintf(fid,'\n\n        ******** Aircraft Perfomace ******** \n\n');
% fprintf(fid,   ['        Display activity log for:  ', datestr(clock), ' \n\n']);
% fclose(fid);
%% Call parameters function and assign parameters

Range_req = Par.Range_req;
MFC       = Par.MFC;
MTOM      = Par.MTOM;
Airframe  = Par.Airframe;
Range_Diversion = Par.Range_Diversion;

%  Set tollerances
Tol_ContCruise         = Par.Tol_ContCruise;
Tol_Diversion          = Par.Tol_Diversion;
Tol_PercentPolicy      = Par.Tol_PercentPolicy;

%% Set the size of the matrices
Range = zeros(1,16);
Time  = zeros(1,16);
Mass  = zeros(1,16);
Fuel  = zeros(1,16);
%% Define the phases
Phase_c = [ '01 | Start of taxi-out                  ',
    '02 | End of taxi-out / Start of take-off',
    '03 | End of take-off / Start of climb   ',
    '04 | End of climb / Start of cruise     ',
    '05 | End of cruise / Start of descent   ',
    '06 | End of descent / Start of approach ',
    '07 | End of approach / Start of taxi-in ',
    '08 | End of taxi-in                     ',
    '09 | Percentage policy reserves         ',
    '10 | Continued cruise reserves          ',
    '11 | End of overshoot / Start of climb  ',
    '12 | End of climb / Start of cruise     ',
    '13 | End of cruise / Start of descent   ',
    '14 | End of descent / Start of hold     ',
    '15 | End of hold / Start of approach    ',
    '16 | End of diversion approach          '];
Phase = cellstr(Phase_c)';

%% Climb & Descent Info:       Part      Type     Method
Info04.Part   = 'Mission';   % Mission   Climb    Forwards
Info04.Type   = 'Climb';     % Mission   Climb    Forwards
Info04.Method = 'Forwards';  % Mission   Climb    Forwards
Info06.Part   = 'Mission';   % Mission   Descent  Backwards
Info06.Type   = 'Descent';   % Mission   Descent  Backwards
Info06.Method = 'Backwards'; % Mission   Descent  Backwards
Info12.Part   = 'Diversion'; % Diversion Climb    Backwards
Info12.Type   = 'Climb';     % Diversion Climb    Backwards
Info12.Method = 'Backwards'; % Diversion Climb    Backwards
Info14.Part   = 'Diversion'; % Diversion Descent  Backwards
Info14.Type   = 'Descent';   % Diversion Descent  Backwards
Info14.Method = 'Backwards'; % Diversion Descent  Backwards

%% Initial values

% Under-estimate of diversion climb range
InitialDiversionClimbRange = 0;

%% First loop to calculate reserves that are indepent of the mission
% Mass at end of reserve approach
Mass(16) = Airframe + Payload;
% Time, range and fuel burn for reserve approach
[Time(16), Range(16), Fuel(16)] = ApproachFunc( Mass(16), EngineData.Approach, Par );

% Mass at end of reserve hold
Mass(15) = Mass(16) + Fuel(16);
% Time, range and fuel burn of reserve hold
[ Time(15), ~, Fuel(15) ] = CruiseFunc( 'Hold', ...
    Mass(14), Mass(15), 0, 0, EngineData.Cruise, ...
    EngineData.Diversion, EngineData.Hold, Par);

% Mass at end reserve descent
Mass(14) = Mass(15) + Fuel(15);
[Time(14), Range(14), Fuel(14)] = ClimbDescentFunc( Mass(14), ...
    Info14, EngineData.Descent, Par);

% Mass at end reserve cruise
Mass(13) = Mass(14) - Fuel(14);
% Loop until the diversion range is 200 nautical miles
Range(13) = InitialDiversionClimbRange; % Set initial climb range to zero

Err_Diversion = Tol_Diversion + 1;      % Set Initial diversion range error
count1 = 0;
while Err_Diversion > Tol_Diversion
    % Counter
    count1 = count1 + 1;
    % Range of diversion cruise
    Range(13) = Range_Diversion - (Range(14) + Range(12));
    % Time and fuel burn of diversion cruise
    [ Time(13), ~, Fuel(13) ] = CruiseFunc('Diversion', Mass(12), ...
        Mass(13), Range(13), 0, EngineData.Cruise, ...
        EngineData.Diversion, EngineData.Hold, Par);
    % Mass at end of reserve climb
    Mass(12) = Mass(13) + Fuel(13);
    % Range and fuel burn of diversion climb
    [Time(12), Range(12), Fuel(12)] = ClimbDescentFunc( Mass(12), ...
        Info12, EngineData.Climb, Par);
    % Total diversion range
    DiversionRange = sum(Range(12:14));
    % Update diversion range error
    Err_Diversion = abs( Range_Diversion - DiversionRange);
end
% Mass at the end of reserve overshoot
Mass(11) = Mass(12) + Fuel(12);
% Time,range and fuel burn of reserve overshoot
[ Time(11), Range(11), Fuel(11) ] = TakeOffFunc( Mass(11), ...
    'Overshoot', Par);
% Mass at start of overshoot
Mass(10) = Mass(11) + Fuel(11);

%% Second loop to find reserves that are dependent on mission

% Initial values
ReserveFuel.ContCruise = 10; % Under-estimate of continued cruise fuel
ReserveFuel.PercPolicy = 10; % Under-estimate of percentage policy fuel
Err_ContCruise    = Tol_ContCruise    + 1;  % Continued cruise error
Err_PercentPolicy = Tol_PercentPolicy + 1;  % Percentage policy error
count2 = 0;

while Err_ContCruise>Tol_ContCruise || Err_PercentPolicy>Tol_PercentPolicy
    % Counter
    count2 = count2 + 1;
    % Normal mission flight time
    FlightTime = sum( Time(3:7) );
    
    % Time, range and fuel burn of reserve continued cruise
    [ Time(10), ~, Fuel(10) ] = CruiseFunc( 'Continued', ...
        Mass(5), Mass(10), 0, 0, EngineData.Cruise, ...
        EngineData.Diversion, EngineData.Hold, Par);
    % Mass at start of overshoot (add on continued cruise reserve)
    Mass(9) = Mass(10) + Fuel(10);
    % Time, range and fuel burn of percentage policy
    [ Time(9), ~, Fuel(9) ] = CruiseFunc( 'PercentPolicy', ...
        Mass(2), Mass(7), 0, FlightTime, EngineData.Cruise, ...
        EngineData.Diversion, EngineData.Hold, Par);
    % Mass at end of approach (add on percentage policy reserve)
    Mass(7) = Mass(9) + Fuel(9);
    % Errors
    Err_ContCruise    = abs( ReserveFuel.ContCruise - Fuel(10) );
    Err_PercentPolicy = abs( ReserveFuel.PercPolicy - Fuel(9) );
    
    % Total reserve fuel
    ReserveFuel.Approach   = Fuel(16);
    ReserveFuel.Hold       = Fuel(15);
    ReserveFuel.Diversion  = sum(Fuel(12:14));
    ReserveFuel.Overshoot  = Fuel(11);
    ReserveFuel.ContCruise = Fuel(10);
    ReserveFuel.PercPolicy = Fuel(9);
    ReserveFuel.Total      = sum(Fuel(9:16));
    
    % Time, range and fuel burn of approach
    [Time(7), Range(7), Fuel(7)] = ApproachFunc(Mass(7), EngineData.Approach, Par );
    % Mass at end of descent
    Mass(6) = Mass(7) + Fuel(7);
    % Time, range and fuel burn of descent
    [Time(6), Range(6), Fuel(6)] = ClimbDescentFunc(Mass(6), Info06, EngineData.Descent, Par);
    % Mass at end of cruise
    Mass(5) = Mass(6) + Fuel(6);
    % Time and fuel burn of taxi-out
    [ Time(2), Range(2), Fuel(2) ] = TaxiFunc('Out', Par);
    % FlightFuel is the fuel used between take-off and landing
    switch flag
        case 'MTOM'
            FlightFuel = MTOM - ( Airframe + Payload + ReserveFuel.Total);
        case 'MFC'
            FlightFuel = MFC  - ( ReserveFuel.Total + Fuel(2) );
        case 'Design'
            FlightFuel = TOM  - ( Airframe + Payload + ReserveFuel.Total);
    end
    % Mass at end of taxi-out
    Mass(2) = Airframe + Payload + FlightFuel + ReserveFuel.Total;
    % Mass at start of taxi-out (ramp mass)
    Mass(1) = Mass(2) + Fuel(2);
    % Time, range and fuel burn of take-off
    [ Time(3), Range(3), Fuel(3) ] = TakeOffFunc( Mass(2), 'Take-off', Par);
    % Mass at end of take-off
    Mass(3) = Mass(2) - Fuel(3);
    % Time, range and fuel burn of climb
    [Time(4), Range(4), Fuel(4), Data] = ClimbDescentFunc(Mass(3), Info04, EngineData.Climb, Par);
    % Mass at end of climb
    Mass(4) = Mass(3) - Fuel(4);
    % Time, range and fuel burn of mission cruise
    [ Time(5), Range(5), Fuel(5) ] = CruiseFunc( 'Mission', Mass(4), ...
        Mass(5), 0, 0, EngineData.Cruise, EngineData.Diversion, ...
        EngineData.Hold, Par);
end
%% Display all errors
% % Display the diversion range error
% filename = 'display.txt';
% fid = fopen(filename,'a');
% fprintf(fid,['Err_Diversion     : ', num2str(Err_Diversion), ' after ', ...
%     num2str(count1), ' iterations of the first loop. \n']);
% fprintf(fid,['Err_ContCruise    : ', num2str(Err_ContCruise), ' after ', ...
%     num2str(count2), ' iterations of the second loop. \n']);
% fprintf(fid,['Err_PercentPolicy : ', num2str(Err_PercentPolicy), ' after ', ...
%     num2str(count2), ' iterations of the second loop. \n']);
% fclose(fid);
% Time, range and fuel burn of taxi-in (taken out of the reserves)
[ Time(8), Range(8), Fuel(8) ] = TaxiFunc('In', Par);
% Mass at end of taxi in
Mass(8) = Mass(7) - Fuel(8);


%% Block data
BlockTime  = sum(Time(1:8));
BlockRange = sum(Range(1:8));
BlockFuel  = sum(Fuel(1:8));
% Total fuel
TotalFuel = sum(Fuel);
% Block
Block.Time=BlockTime;
Block.Range=BlockRange;
Block.Fuel=BlockFuel;
% Mission
Mission.Time  = Time;
Mission.Range = Range;
Mission.Fuel  = Fuel;
Mission.Mass  = Mass;
Mission.Phase = Phase';
Mission.Data  = Data;

% diff for fsolve function
switch flag
    case {'MTOM', 'MFC'}
        diff = MTOM - (Airframe + Payload - Fuel(2)) - MFC;
    case 'Design'
        diff = Range_req - BlockRange;
end
% toc
fprintf('.')


[ROC_ceiling, ind] = min(abs(Data.ROC_fpm(Data.ROC_fpm<0)));
h_val = Data.h_ft(Data.ROC_fpm<0);
h_ceiling =h_val(ind);
if  ~isempty(h_ceiling)
    disp(['Warning: ... Altitude Ceiling reached for Mission Climb just below ' num2str(round(h_ceiling)) ' ft. The RoC this altitude is ' num2str(-ROC_ceiling)])
%     return
end
end

