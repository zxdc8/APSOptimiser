%////////MAIN FILE - RUN THIS/////////
fclose('all');
close all
clear all

delete('././TIC/*.txt');

echo off all
tstart = tic;
%set iteration file-workaround
% filename='iteration.csv';
% ifile=fopen(filename,'w');
% fprintf(ifile,'1');
% 
% fclose(ifile);
%     
%Define x0 - Start Point
%And Upper/Lower Bounds, format:
%Scale  Root/mid/tip%
%X      mid/tip
%Z      mid/tip
alpha = 0;
target_cmtot = -0.01;
alpha_tol = 0.01; % 1% tolerance from target Cm

x0=[50 30 15 30 40 10 10];
% x0=[20 15 10 5 30 10 40];
LB=[20 15 10 0 0 10 10];
UB=[72 72 72 72 72 35 40];

% iter=randi([0 1000000]);

%Write AVL case file and get filename, constraint values
% [filename]=aeromodule(x0,iter);

%Define Objective Function
objFun=@(x)ObjConWrapper(x);
% constFun = @(x)constraintspso(x);


%Interior Point Algorithm
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',1,'FunctionTolerance',1e-3,'StepTolerance',1e-12,'PlotFcns',@optimplotfval,'MaxIterations',40,'UseParallel',true);


%Run Optimisation
[X,J,EXITFLAG,OUTPUT]=fmincon(objFun,x0,[],[],[],[],LB,UB,[],options);   

%Generate Final AVL case file
%[filename, iter]=aeromodule(X)

%AVLcall(filename,'mass_1.avl','w.run',iter);
fclose('all');

%% Output geometry and save file
saveas(gcf,'Step_IP2')

vis3D(X)
save('J_IP2.mat','J')
save('Details_IP2.mat','OUTPUT')
save('GeometryOpt_IP2.mat','X')

tEnd = toc(tstart)
