%% Define test run to view
%Outputs graph for wing, conversion, ranges of particles and outputs.
close all
clear all

n = 1;

%% Load in variables

pathfile1 =sprintf('././GA/Details_%.0f.mat',n);
pathfile2 =sprintf('././GA/fval_%.0f.mat',n);
pathfile3 =sprintf('././GA/Geom_%.0f.mat',n);
pathfile4 =sprintf('././GA/pop_%.0f.mat',n);
pathfile5 =sprintf('././GA/scores_%.0f.mat',n);
pathfile6 =sprintf('././GA/Step_%.0f',n);
%Iteraiton and Particle position
load(pathfile1)
load(pathfile2)
load(pathfile3)
load(pathfile4)
load(pathfile5)

openfig(pathfile6)


%% Visualise best wing

vis3D(X)







