%% Run Design Set
% This file (RunDesignSet) illustrates how to calculate mission parameters (mass, fuel and
% range) for a set of design missions defined by a target payload, target range and aircraft parameters.
% The climb performance parameters are also calculated.
% 
% The main file for running the Design Case is *FindDesignPoint*
% For brief description type: _help FindDesignPoint_
% 
% Created by: D Rezgui and S Mitchell
% Copyright: University of Bristol

%% Initialise aircraft parameters
% delete Par; clear Par
clear; clc
disp(' ')
disp('        ******** Aircraft Performance Tool ********');
disp('        ******** Run Design Mission Case ********')
disp(['                  ', datestr(clock)]);
disp(' ')

% Read Aircraft data from a re-defined file, e.g. 'AC_B777_AJenk'or 'AC_150C_twin'
ParFunc = 'BWB'; % or ParFunc = 'AC_150C_twin';
Par     = eval(ParFunc);  % Set parameters in the "Par" object, 
                          % Default values are set in the ParFunc

disp(['... Aircraft parameters are set, based on ', ParFunc, ' data file'])
disp(' ')



% Reset engine data parameters (if needed)
Par.interp_method = 'spline'; % or 'spline' - 'spline' is slower but allows to extrapolate data 

Par.M_ext = []; % Extend Mach number range to M_ext - change to something like 0.1 if needed 
Par.DragRise = 0;

%% Calculate the mass, fuel and range for a set of missions
% Find mission properties for a set of Mach numbers

% Define a set of cruise numbers

% par_set = 0.5:0.05:0.8; % Define an appropriate parameter range

xlab = 'Mach Cruise Speed [-]'; % Define a label for the parameter used for the parameter set

% Find results for the first design point (i=1)
i = 1;
% disp(['Start calculations for design point number: ' num2str(i)  ' value: ' num2str(par_set(i))]);
% Set target design range. All other parameters are unchanged


Par.Mach_Cruise = 0.7;
Par.Alt_Cruise = 35000;
Par.S = 300;




% call function FindDesignPoint to calculate mission properties
dp1(i) = FindDesignPoint(Par);
    

%% Save results
savefile = 'NewTanksV2.mat';
%save(savefile, 'dp1', 'dp2', 'par_set','xlab');
% save(savefile, 'dp1', 'par_set','xlab');
save(savefile, 'dp1');
%% Load saved data to workspace

clear % clear workspace
load 'NewTanksV2.mat';
whos % show available variables in the workspace

