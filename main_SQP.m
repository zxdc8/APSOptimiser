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
x0=[40 30 15 30 40 15 20];
LB=[20 15 5 0 0 10 10];
UB=[40 40 40 40 72 35 40];


%Write AVL case file and get filename, constraint values
[filename,iter,At]=aeromodule(x0);

%Define Objective Function
objFun=@(x)objective(x);


%SQP Algorithm
options = optimoptions('fmincon','Algorithm','sqp','Display','iter-detailed','FiniteDifferenceStepSize',1,'FunctionTolerance',1e-2,'StepTolerance',1e-10,'PlotFcns',{@optimplotfval,@optimplotx,@optimplotfirstorderopt,@optimplotstepsize},'MaxIterations',30);

%Run Optimisation
[x,fval,exitflag,details,lambda,grad,hessian]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options);



output.lambda = lambda;
output.grad = grad;
output.hessian = hessian;

%AVLcall(filename,'mass_1.avl','w.run',iter);
fclose('all');


saveas(gcf,'././SQP/fig_1')
%% Output geometry and save file

vis3D(x)

save('././SQP/J_1.mat','fval')
save('././SQP/Details_1.mat','details')
save('././SQP/X_1.mat','x')
save('././SQP/output_1.mat','output')

tEnd = toc(tstart)