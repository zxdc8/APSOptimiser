%% Find the fuel required for a given payload and given range
% Payload
Payload = 30000;
% MFC
MFC = 80000;
% Flag
flag = 'Design';
% Pre-process the tabulated engine data into a grid structure
EngineData.Climb   = EngineGridFunc( 'Climb', 1 );   % Climb
EngineData.Cruise  = EngineGridFunc( 'Cruise', 1 );  % Mission Cruise
EngineData.Descent = EngineGridFunc( 'Descent', 1 ); % Descent
EngineData.MaxCont = EngineGridFunc( 'MaxCont', 0 ); % Diversion Cruise
% Design Range
DesignRange = 5000;

% Define the handle to MissionProfile function for design case
MProfile3  = @(TOM) MissionProfile(Payload, MFC, flag, EngineData, TOM, DesignRange);
% Set an initial estimate for the take-off mass
TOM_0      = 220000;    % kg
% Set the options for the fsolve function
options    = [];
% Calculate the payload at the junction point
TOM_design = fsolve(MProfile3,TOM_0,options);

% Calculate the range at the junction point
[Fuel_diff, TotalFuel, Block, Mission] = MProfile3(TOM_design);
Range_p = Block.Range;