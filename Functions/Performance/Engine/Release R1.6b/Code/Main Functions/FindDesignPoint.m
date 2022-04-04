function dp = FindDesignPoint(Par, EngineData, TOM_0)
% dp = FindDesignPoint(Par, EngineData, TOM_0)
% FindDesignPoint calculate mission mass, range and fuel given a target
% payload and block range
% 
% Input:
% Par       : Object of aircraft parameters
% EngineData: Structure if aircraft engine data (output of
%             GriddedEngineData.m) [optional]
% TOM_0: Initial value for TOM [optional]
% 
% Output:
% dp: object contains design point (dp) results
%
% Created by D Rezgui, 2017, University of Bristol 
%
% See also GriddedEngineData

%% Test
if nargin < 1
    Par = AC_DP2001; % or ParFunc = 'AC_150C_twin';
end

% Pre-process the tabulated engine data into a grid structure
if nargin <2
    EngineData = GriddedEngineData(Par);
end

if nargin <3
    TOM_0  = Par.Airframe+Par.MFC; % [kg], Set an initial estimate for the take-off mass
end


%% Update Kink altitude values
Par.Alt_kink_Mis_Climb = KinkFunc(Par.CAS_Mis_ClimbHigh, Par.Mach_Mis_Climb);
Par.Alt_kink_Mis_Descent = KinkFunc(Par.CAS_Mis_DescentHigh, Par.Mach_Mis_Descent);
Par.Alt_kink_Div_Climb = KinkFunc(Par.CAS_Div_ClimbHigh, Par.Mach_Div_Climb);
Par.Alt_kink_Div_Descent = KinkFunc(Par.CAS_Div_DescentHigh, Par.Mach_Div_Descent);

%% Calculate the take off mass for design case
PL_req = Par.PL_req;% Required payload mass [kg]
% options = [];    % Set the options for the fsolve function
options = optimoptions('fsolve','Display','off');  % Turn off display

% Define 'TOM' as a handle to the MissionProfile function for Design case
MProfile2 = @(TOM) MissionProfileFunc(PL_req, 'Design', EngineData, TOM, Par);

disp('... Calculating the value of aircraft Take-Off Mass (TOM) for the required design case')
disp(['Payload required :  ' ,num2str(PL_req        ), ' kg']);
disp(['Range required   :  ' ,num2str(Par.Range_req ), ' nm']);
disp(['Cruise altitude  :  ' ,num2str(Par.Alt_Cruise), ' ft']);
disp(['Cruise Mach No.  :  ' ,num2str(Par.Mach_Cruise), ' ']);
disp(' ')
% Calculate the value of TOM for the design case by driving the output
% 'diff' to zero
TOM_design = fsolve(MProfile2,TOM_0,options);

disp('... Done')

disp(' ')

%% Calculate fuel burn for the design case

disp('Calculate fuel burn for the required design case')

% Calculate the output values by inputting TOM_design into MProfile2
[~, TotalFuel, Block, Mission] = MProfile2(TOM_design);

disp('... Done')

disp(' ')

% Display the TOM
disp(['TOM for required the mission  :  ' ,num2str(round(TOM_design)), ' kg']);

% Find block fuel and reserve fuel
BlockFuel   = Block.Fuel;
ReserveFuel = TotalFuel - (BlockFuel - Mission.Fuel(8));

disp(['Block time for the mission    :  ' ,num2str(round(Block.Time)  ), ' minutes']);
% Display the block, reserve and total fuel
disp(['Block fuel for the mission    :  ' ,num2str(round(BlockFuel  )), ' kg']);
disp(['Reserve fuel for the mission  :  ' ,num2str(round(ReserveFuel)), ' kg']);
disp(['Total fuel for the mission    :  ' ,num2str(round(TotalFuel  )), ' kg']);
disp(' ')

%% Set DP (DesignPoint) object
dp = designpoint; % define dp object as designpoint class
dp.PL_req       = PL_req;
dp.Range_req    = Par.Range_req;
dp.Par          = Par;
dp.EngineData   = EngineData;
dp.Mission      = Mission;
dp.Block        = Block;
dp.TotalFuel    = TotalFuel;
dp.ReserveFuel  = ReserveFuel;
dp.TOM_design   = TOM_design;
