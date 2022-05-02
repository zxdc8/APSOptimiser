%% Define test run to view
%Outputs graph for wing, conversion, ranges of particles and outputs.
close all
clear all

n = 1;

%% Load in variables

pathfile1 =sprintf('././PS/Details_%.0f.mat',n);
pathfile2 =sprintf('././PS/fval_%.0f.mat',n);
pathfile3 =sprintf('././PS/Geom_%.0f.mat',n);


pathfile6 =sprintf('././PS/Step_%.0f',n);
%Iteraiton and Particle position
load(pathfile1)
load(pathfile2)
load(pathfile3)


openfig(pathfile6)


%% Visualise best wing

vis3D(X)







