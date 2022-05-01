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

x0=[40 30 15 30 40 15 20]; % run 1
% x0=[30 20 10 10 30 10 15]; % run 2
LB=[20 15 5 0 0 10 10];
UB=[40 40 40 40 72 35 40];

%Write AVL case file and get filename, constraint values
[filename,iter,At]=aeromodule(x0);

%Define Objective Function
objFun=@(x)objective(x);

%Define solver options - Active set Algorithm
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',1,'FunctionTolerance',1e-2,'StepTolerance',1e-10,'PlotFcns',{@optimplotfval,@optimplotx,@optimplotfirstorderopt,@optimplotstepsize},'MaxIterations',30);


%Run Optimisation
[x,fval,exitflag,details,lambda,grad,hessian]=fmincon(objFun,x0,[],[],[],[],LB,UB,@constraints,options);



output.lambda = lambda;
output.grad = grad;
output.hessian = hessian;

%AVLcall(filename,'mass_1.avl','w.run',iter);
fclose('all');



%% Output geometry and save file
saveas(gcf,'././AS/fig_1')
vis3D(x)

save('././AS/J_1.mat','fval')
save('././AS/Details_1.mat','details')
save('././AS/X_1.mat','x')
save('././AS/output_1.mat','output')

tEnd = toc(tstart)
