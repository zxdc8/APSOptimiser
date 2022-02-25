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
x0=[10 2 10 20 15 20 5]

[X,J]=fmincon(@(x)aeromodule(x),x0,[],[])

fclose('all');