%////////MAIN FILE - RUN THIS/////////
fclose('all');
close all
clear all

echo off all
tstart = tic;
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
[filename,At]=aeromodule(x0);

%Define Objective Function
objFun=@(x)objective(x);


%Interior Point Algorithm
options = optimoptions('fmincon','Algorithm','interior-point','Display','iter-detailed','FiniteDifferenceStepSize',2,'FunctionTolerance',1e-3,'StepTolerance',1e-7,'PlotFcns',@optimplotfval,'MaxIterations',25);


%Run Optimisation
[x0]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options); 

saveas(gcf,'Step_IPAS4')

fclose('all')

%Define solver options - Active set Algorithm
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',3,'FunctionTolerance',1e-3,'StepTolerance',1e-7,'PlotFcns',@optimplotfval,'MaxIterations',30);

%Run Optimisation
[X,J,EXITFLAG,OUTPUT]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options);   
saveas(gcf,'Step_ASS4')

%AVLcall(filename,'mass_1.avl','w.run',iter);
fclose('all');

%% Output geometry and save file

vis3D(X)
save('J_IPAS4.mat','J')
save('Details_IPAS4.mat','OUTPUT')
save('GeometryOpt_IPAS4.mat','X')

openfig('Step_IPAS4')

tEnd = toc(tstart)
