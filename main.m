%////////MAIN FILE - RUN THIS/////////
fclose('all')
close all
clear all

%set iteration file-workaround
filename='iteration.csv';
ifile=fopen(filename,'w');
fprintf(ifile,'1');

fclose(ifile);

%Define x0 - Start Point
%And Upper/Lower Bounds, format:
%Scale  Root/mid/tip%
%X      mid/tip
%Z      mid/tip

x0=[10 5 2 5 10 7.5 7.5];
LB=[1 1 1 0 0 0 0];
UB=[60 60 60 60 60 16 16];

%Write AVL case file and get filename, constraint values
[filename,iter,At]=aeromodule(x0);

%Define Objective Function
[objFun]=@(x)objective(x);

%Define solver options
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',0.5,'FunctionTolerance',1e-6,'PlotFcns',@optimplotfval);

%Run Optimisation
[X,J]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options)

fclose('all');