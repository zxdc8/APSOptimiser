clear all
close all
%% Run Design Case
% This file (RunDesignCase) illustrates how to calculate mission parameters (mass, fuel and
% range) for a set of design missions defined by a target payload, target range and aircraft parameters.
% The climb performance parameters are also calculated.
% 
% The main file for running the Design Case is *FindDesignPoint*
% For brief description type: _help FindDesignPoint_
% 
% Created by: *D Rezgui*, *S Mitchell*
% Copyright: University of Bristol

%% Initialise aircraft parameters
% delete Par; clear Par
clear; clc
disp(' ')
disp('        ******** Aircraft Performance Tool ********');
disp('        ********  Run Design Mission Set ********')
disp(['                  ', datestr(clock)]);
disp(' ')

% Read Aircraft data from a re-defined file, e.g. 'AC_B777_AJenk'or 'AC_150C_twin'
%ParFunc = 'Flh2y_Iter1'; % or ParFunc = 'AC_150C_twin';
ParFunc = 'Flh2y_Iter1_NewTanksV2';
Par     = eval(ParFunc);  % Set parameters in the "Par" object, 
                          % Default values are set in the ParFunc

disp(['... Aircraft parameters are set, based on ', ParFunc, ' data file'])
disp(' ')

% Reset parameters from default values (other parameters can be changed in
% the Par object)         
%Par.PL_req    = 29050; % Required payload mass [kg]
Par.Range_req =  500; % Required design range [nm]
Par.Alt_Cruise    		 = 24000;
% You can also reset the following parameters. (you can also change these parameters in the ParFunc file)
% Par.S                      = 376.4;     % Wing area [m^2]
% Par.PLmax                  = 45000;     % Max payload [kg]
% Par.MFC                    = 80000;     % Max Fuel capacity [kg]
% Par.MTOM                   = 230000;    % Max Take Off Mass [kg]
% Par.Airframe               = 130000;    % Operating Mass Empty [kg]
% Par.Alt_Cruise    		 = 35000;     % Cruise Alt [ft]
% Par.DragRise  	  		 = 0;     % Flag to switch drag rise in the drag polar: 1 = Yes, 0 = No

% Reset engine data parameters (if needed)
Par.interp_method = 'linear'; % or 'spline' - 'spline' is slower but allows to extrapolate data 
Par.M_ext = []; % Extend Mach number range to M_ext - change to something like 0.1 if needed 

%% Calculate the mass, fuel and range for required mission
% Find mission mass, fuel and range for each mission phase
% Call function FindDesignPoint to calculate mission characteristics
dp(1) = FindDesignPoint(Par); % The calculated results of the mission elements are store in the object *dp*.

% Display Mission elements
Mission = dp.Mission

% Display Mission phases
Phase = dp.Mission.Phase

%% Plot Mission Profile, Climb Performance results are also plotted
PlotMission(dp(1).Mission) % Call plotter for mission profile
% PlotMission2(dp(1).Mission); % Plotter for MATALB before R2015

%% Calculate the mass, fuel and range for a second mission with reduced required range
Par.Range_req  =  500;
Par.Alt_Cruise = 27000;% Required design range [nm]
% Call function FindDesignPoint to calculate mission characteristics
%dp(2) = FindDesignPoint(Par); % The calculated results of the mission elements are store in the object *dp*.

% Plot Mission Profile, Climb Performance results are also plotted
%PlotMission(dp(2).Mission) % Call plotter for mission profile
% PlotMission2(dp(2).Mission); % Plotter for MATALB before R2015

%% Calculate the mass, fuel and range for a third mission with higher cruise altitude
Par.Range_req  =  500; % Required design range [nm]
Par.Alt_Cruise = 29000; % Cruise Alt [ft]
% Call function FindDesignPoint to calculate mission characteristics
%dp(3) = FindDesignPoint(Par); % The calculated results of the mission elements are store in the object *dp*.

% Plot Mission Profile, Climb Performance results are also plotted
%PlotMission(dp(3).Mission) % Call plotter for mission profile
% PlotMission2(dp(3).Mission); % Plotter for MATALB before R2015

%% Save results
savefile = 'NewTankV2.mat'; % You should change the name of this file for different cases
save(savefile, 'dp');

%% Load saved data to workspace
% delete Par; 
clear % clear workspace
load 'NewTankV2.mat';
whos % show available variables in the workspace
