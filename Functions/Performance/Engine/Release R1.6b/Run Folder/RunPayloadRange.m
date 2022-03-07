%% Payload Range Diagram
% RunPayloadRange computes and plots the payload-range diagram
% 
% The main file for running the Design Case is *FindDesignPoint*
% For brief description type: _help FindDesignPoint_
% 
% Created by: D Rezgui and S Mitchell
% Copyright: University of Bristol

%% Initialise aircraft parameters
% delete Par; clear Par; 
clear; clc
disp(' ')
disp('        ******** Aircraft Performance Tool ********');
disp('        ********  Payload Range Diagram ********')
disp(['                  ', datestr(clock)]);
disp(' ')

% Read Aircraft data from a re-defined file, e.g. 'AC_B777_AJenk'or 'AC_150C_twin'
ParFunc = 'Flh2y_Iter1_NewTanksV2'; % or ParFunc = 'AC_150C_twin';
Par     = eval(ParFunc);  % Set parameters in the "Par" object, 
                          % Default values are set in the ParFunc

disp(['... Aircraft parameters are set, based on ', ParFunc, ' data file'])
disp(' ')

% Reset parameters from default values (other parameters can be changed in
% the Par object)         
Par.PL_req    = 7600; % Required payload mass [kg]

% Reset engine data parameters (if needed)
Par.interp_method = 'linear'; % or 'spline' - 'spline' is slower but allows to extrapolate data 
Par.M_ext = []; % Extend Mach number range to M_ext - change to something like 0.1 if needed 

%% Payload range diagram for case : MTOM = 230000 kg (Max Take Off Mass)

% Calculate the properties of the payload range diagram
plrd(1) = FindPayloadRangeDiag(Par);

% Plot the payload range diagram
PlotPLRD(plrd(1), 'b') % call plotter for payload range diagram

% Plot Mission Profile
PlotMission(plrd(1).dp.Mission) % Call plotter for mission profile
% PlotMission2(plrd(1).dp.Mission); % Plotter for MATALB before R2015


%% Save results
savefile = 'PayloadRange.mat';
save(savefile, 'plrd');
