%% Figure visualiser for the fmincon function
%Define Algorithm to view - 'AS': Active-set, 'SQP': Sequential Quadratic
%Programming, 'IP' - Interior Point
clear all
close all

algo = "IP";

%run
n = 1;

%% load
load1 = sprintf('././%s/J_%d.mat',algo,n);
load(load1)

load2 = sprintf('././%s/Details_%d.mat',algo,n);
load(load2)

load3 = sprintf('././%s/X_%d.mat',algo,n);
load(load3)

load4 = sprintf('././%s/output_%d.mat',algo,n);
load(load4)

fig = sprintf('././%s/fig_%d',algo,n);
openfig(fig)

%%


vis3D(x)


funcevals = details.funcCount
iterations = details.iterations