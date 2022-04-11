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
alpha = 0;
target_cmtot = -0.01;
alpha_tol = 0.01; % 1% tolerance from target Cm

%x0=[50 30 15 30 40 10 10];
x0=[40 20 10 20 40 40 40];
LB=[20 15 10 0 0 10 10];
UB=[72 72 72 72 72 35 40];

%Write AVL case file and get filename, constraint values
[filename,iter,At]=aeromodule(x0);

%Define Objective Function
objFun=@(x)objective(x);

%Define solver options 
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',2,'FunctionTolerance',1e-6,'StepTolerance',1e-7,'PlotFcns',@optimplotfval);

%Run Optimisation
[X,J]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options)   

%Generate Final AVL case file
%[filename, iter]=aeromodule(X)

%AVLcall(filename,'mass_1.avl','w.run',iter);

fclose('all');