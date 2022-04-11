function plrd = FindPayloadRangeDiag(Par, EngineData, Payload_0)
% output=FindDesignPoint(PL_req, EngineData, Par)
%
% This function calculate mission mass, range and fuel given a target
% payload and block range
% 
% Created by: D Rezgui 
% University of Bristol

%% Check inputs
if nargin < 1
    Par = AC_DP2001; % or ParFunc = 'AC_150C_twin';
end

% Pre-process the tabulated engine data into a grid structure
if nargin < 2
    EngineData = GriddedEngineData(Par);
end

if nargin < 3
    Payload_0 = Par.PLmax; % [kg], Set an initial estimate for the payload at the junction point
end
tic

%% Update Kink Altitude values
Par.Alt_kink_Mis_Climb = KinkFunc(Par.CAS_Mis_ClimbHigh, Par.Mach_Mis_Climb);
Par.Alt_kink_Mis_Descent = KinkFunc(Par.CAS_Mis_DescentHigh, Par.Mach_Mis_Descent);
Par.Alt_kink_Div_Climb = KinkFunc(Par.CAS_Div_ClimbHigh, Par.Mach_Div_Climb);
Par.Alt_kink_Div_Descent = KinkFunc(Par.CAS_Div_DescentHigh, Par.Mach_Div_Descent);

%% Identify the junction point at which the MTOM curve meets the MFC curve
% options   = [];    % Set the options for the fsolve function
options = optimoptions('fsolve','Display','off');  % Turn off display

% Define 'Payload' as a handle to the MissionProfile function for MTOM and MFC cases
MProfile1 = @(Payload) MissionProfileFunc(Payload, 'MTOM', EngineData,0, Par);
disp('Calculate the value of payload at the intersection point of MTOM curve with MFC line')

% Calculate the value of payload at the junction point by driving the
% parameter 'diff' to zero
Payload_p = fsolve(MProfile1,Payload_0,options);

disp('... Done')
disp(' ')

% Calculate the value of range at the junction point by inputting Payload_p
% into MProfile1
disp('Calculate the value of range at the intersection point of the MTOM curve with MFC curve')
[~, ~, Block, ~] = MProfile1(Payload_p);
Range_p = Block.Range;

disp('... Done')
disp(' ')

%% Calculate points along the curves that define the payload range diagram
disp('Calculate the points along the curves that define the payload range diagram')

disp('For the MTOM curve, calculating the range at each point')
PLmax  = Par.PLmax;        % Maximum payload mass         [kg]
% For the MTOM case, define the payload increments
Payload_MTOM = linspace(Payload_p,PLmax,Par.NP_MTOM);

% For the MTOM case, calculate the range at each point
Range_MTOM   = MissionProfileFuncVec(Payload_MTOM, 'MTOM', EngineData, 0, Par);

disp('... Done')
disp(' ')

disp('For the MFC curve, calculating the range at each point')
% For the MFC case, define the payload increments
Payload_MFC = linspace(0,Payload_p,Par.NP_MFC);
% For the MFC case, calculate the range at each point
Range_MFC   = MissionProfileFuncVec(Payload_MFC, 'MFC', EngineData, 0, Par);

disp('... Done')
disp(' ')

%% Calculate the range for the required design payload
PL_req = Par.PL_req;
disp('Calculating the range for the required design payload')
% For the MFC case, define the payload increments
if (PL_req>=Payload_p) && (PL_req<=PLmax)
    % If required design point in the MTOM curve
% Payload_MTOM = sort([linspace(Payload_p,PLmax,10) PL_req]);
    [~, TotalFuel, Block, Mission] = MissionProfileFunc(PL_req, 'MTOM', EngineData, 0, Par);
elseif (PL_req<Payload_p)
    % If required design point in the MFC curve
    [~, TotalFuel, Block, Mission] = MissionProfileFunc(PL_req, 'MFC', EngineData, 0, Par);
elseif (PL_req>PLmax)
    disp('Warning: ... required design point payload is higher than the max payload!!!') 
    disp('... Recalculating for Max payload case.');
    [~, TotalFuel, Block, Mission] = MissionProfileFunc(Par.PLmax, 'MTOM', EngineData, 0, Par);
    PL_req = Par.PLmax;
end

ReserveFuel = TotalFuel - (Block.Fuel - Mission.Fuel(8));

dp = designpoint; % define dp object as designpoint class
dp.PL_req       = PL_req;
dp.Range_req    = Block.Range;
dp.Par          = Par;
dp.EngineData   = EngineData;
dp.Mission      = Mission;
dp.Block        = Block;
dp.TotalFuel    = TotalFuel;
dp.ReserveFuel  = ReserveFuel;
dp.TOM_design   = Mission.Mass(2);

disp('... Done')
disp(' ')
%% Set PLRD (DesignPoint) object
plrd = payloadrange; % define dp object as designpoint class

plrd.Payload_p       = Payload_p;
plrd.Range_p         = Range_p; 
plrd.PLmax           = PLmax;
plrd.Range_PLmax     = Range_MTOM(end);
plrd.Payload_MTOM    = Payload_MTOM;
plrd.Range_MTOM      = Range_MTOM;
plrd.Range_MFC       = Range_MFC;
plrd.Payload_MFC     = Payload_MFC;
plrd.Range_max       = Range_MFC(1);
plrd.dp              = dp;
plrd.Par             = Par;
plrd.EngineData      = EngineData;
