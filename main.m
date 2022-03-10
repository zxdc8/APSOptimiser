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
% x0=[10 5 5 10 10 20 5];
x0=[10 10 10 0 0 10 10];

%Write AVL case file and get filename, constraint values
[filename,iter,At]=aeromodule(x0);

%Define Constraints
%consts=@constraints(At);

%Set Limits
% LB=[5 2 2 5 2 4 2];
% UB=[20 15 15 30 20 40 10];

LB=[1 1 1 0 0 0 0];
UB=[50 50 50 50 50 7.5 7.5];

%Define Objective Function
[objFun]=@(x)objective(x);

%Define solver options
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',0.5,'FunctionTolerance',1e-10,'PlotFcns',@optimplotfval);

%Run Optimisation
[X,J]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options)

fclose('all');