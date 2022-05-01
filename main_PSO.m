%////////MAIN FILE - RUN THIS/////////
fclose('all');
close all
clear all

% delete('././TIC/*.txt');

echo off all
tstart = tic;
%set iteration file-workaround
% filename='iteration.csv';
% ifile=fopen(filename,'w');
% fprintf(ifile,'1');
% 
% fclose(ifile);

key=randi([0 1000000]);

%     
%Define x0 - Start Point
%And Upper/Lower Bounds, format:
%Scale  Root/mid/tip%
%X      mid/tip
%Z      mid/tip
alpha = 0;
target_cmtot = -0.01;
alpha_tol = 0.01; % 1% tolerance from target Cm

% x0=[50 30 15 30 40 10 10];
% x0=[40 20 10 20 40 40 40];
LB=[20 15 10 0 0 10 10];
UB=[40 40 30 30 70 30 60];

% iter=randi([0 1000000]);

%Write AVL case file and get filename, constraint values
% [filename]=aeromodule(x0,iter);

%Define Objective Function
objFun=@(x)ObjConWrapper(x);
% constFun = @(x)constraintspso2(x,key);


%GA Algorithm
options = optimoptions('particleswarm','Display','iter','SwarmSize',100,'FunctionTolerance',1e-2,'PlotFcn',{@pswplotbestf},'UseParallel',true);


%Run Optimisation
[X,fval,exitflag,output]=particleswarm(objFun,7,LB,UB,options);   


% %Interior Point Algorithm
% options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',2,'FunctionTolerance',1e-2,'StepTolerance',1e-7,'PlotFcns',@optimplotfval,'MaxIterations',25);
% 
% 
% %Run Optimisation
% [X]=fmincon(objFun,x0,[],[],[],[],LB,UB,constFun,options); 


%Generate Final AVL case file
%[filename, iter]=aeromodule(X)

%AVLcall(filename,'mass_1.avl','w.run',iter);
fclose('all');

%% Output geometry and save file
saveas(gcf,'././PSO/Step_2')

vis3D(X)
save('././PSO/fval_2.mat','fval')
save('././PSO/Details_2.mat','output')
save('././PSO/Geom_2.mat','X')

tEnd = toc(tstart)