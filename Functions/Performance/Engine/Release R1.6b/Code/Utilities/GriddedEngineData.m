function EngineData = GriddedEngineData(Par)
% EngineData = GriddedEngineData(Par)
%
% GriddedEngineData pre-processes the available engine data to a set of
% useablle interpolated tables.
% 
% Input: 
% Par : object of aircraft  parameters
% 
% Output:
% EngineData : engine tables for Cruise, Climb, Descent, Hold, Diversion 
% and Approach
%
% Created by D Rezgui 2017, University of Bristol 

if nargin < 1
    Par = AC_DP2001;
end

M_ext = Par.M_ext;
EngFileName = Par.EngFileName;

EngineData.Climb      = EngineGridFunc3( 'Climb'     , 1, EngFileName, M_ext ); % Climb
EngineData.Cruise     = EngineGridFunc3( 'Cruise'    , 1, EngFileName, M_ext ); % Mission Cruise
EngineData.Descent    = EngineGridFunc3( 'Descent'   , 1, EngFileName, M_ext ); % Descent
EngineData.Diversion  = EngineGridFunc3( 'Diversion' , 1, EngFileName, M_ext ); % Diversion Cruise
EngineData.Hold       = EngineGridFunc3( 'Hold'      , 1, EngFileName, M_ext ); % Hold
EngineData.Approach   = EngineGridFunc3( 'Approach'  , 1, EngFileName, M_ext ); % Approach

disp(' ');
disp(['... Engine data prepared from ' EngFileName]);
disp(' ');
end

