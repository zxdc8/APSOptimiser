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
x0 = [20 15 10 17 45 26 14]; 

LB=[20 15 10 0 0 10 10];
UB=[40 40 30 30 70 30 60];


%Define Objective Function
objFun=@(x)ObjConWrapper(x);


%Interior Point Algorithm
options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed','FiniteDifferenceStepSize',2,'FunctionTolerance',1e-3,'StepTolerance',1e-10,'PlotFcns',@optimplotfval,'MaxIterations',35,'UseParallel',true);


%Run Optimisation
[X,fval,output]=fmincon(objFun,x0,[],[],[],[],LB,UB,[],options); 





%% Output geometry and save file
saveas(gcf,'././IPAS/Step_1')

vis3D(X)
save('././IPAS/fval_1.mat','fval')
save('././IPAS/Details_1.mat','output')
save('././IPAS/Geom_1.mat','X')


tEnd = toc(tstart)
