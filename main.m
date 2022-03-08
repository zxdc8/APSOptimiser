close all
clear all

%set iteration file-workaround
filename='iteration.csv';
ifile=fopen(filename,'w');
fprintf(ifile,'1');

fclose(ifile);

%define objective function - for example, fmincon only considering Cl, Cd

% This isn't working yet but i cba to find out why, will probably use a
% better method anyway
%
x0=[10 5 5 10 10 20 5]
%x0=[15 2]
LB=[5 2 2 5 2 4 2] 
UB=[20 15 15 30 20 40 10]

options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',0.5,'FunctionTolerance',1e-10);
[X,J]=fmincon(@aeromodule,x0,[],[],[],[],LB,UB,[],options)

fclose('all');