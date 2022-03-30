%////////MAIN FILE - RUN THIS/////////
fclose('all')
close all
clear all

%set iteration file-workaround
filename='iteration.csv';
ifile=fopen(filename,'w');
fprintf(ifile,'1');

fclose(ifile);

%Joe's Parameters
L=20;
N = 3; %Total no. of segment sides to make Wing modules 
Np = 2; %No. of segment sides dedicated to Passenger Cabin modules


%Establish Weights of BWB components
Struc_Mass = 131375; %weight of wing structures
Payload_Mass = 105160; %weight of Passengers
Fuel_Mass = 390720; %weight of fuel @ take-off
    
%Define x0 - Start Point
%And Upper/Lower Bounds, format:
%Scale  Root/mid/tip%
%X      mid/tip
%Z      mid/tip
alpha = 0;
target_cmtot = -0.01;
alpha_tol = 0.01; % 1% tolerance from target Cm

x0=[50 30 15 30 40 10 10];
LB=[20 5 5 0 0 5 5];
UB=[72 72 72 72 72 35 40];

%Write AVL case file and get filename, constraint values
[filename,iter,At]=aeromodule(x0);

%Define Objective Function
[objFun]=@(x)objective(x);

%Define solver options
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',0.5,'FunctionTolerance',1e-7,'PlotFcns',@optimplotfval);

%Run Optimisation
[X,J]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options)

%Generate Final AVL case file
[filename, iter]=aeromodule(X)

AVLcall(filename,'mass_1.avl','w.run',iter);

fclose('all');