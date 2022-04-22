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
x0=[40 20 10 20 40 40 40];
LB=[20 15 10 0 0 10 10];
UB=[40 40 30 30 70 30 60];

% iter=randi([0 1000000]);

%Write AVL case file and get filename, constraint values
% [filename]=aeromodule(x0,iter);

%Define Objective Function
objFun=@(x)ObjConWrapper(x);
% constFun = @(x)constraintspso2(x,key);


%GA Algorithm
options = optimoptions('simulannealbnd','Display','iter','FunctionTolerance',1e-2,'PlotFcn',{@saplotbestx,@saplotbestf,@saplotx,@saplotf,@saplottemperature},'UseParallel',true);


%Run Optimisation
[X,fval,exitflag,output,population,scores]=ga(objFun,x0,LB,UB,options);   


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
saveas(gcf,'././GA/Step_1')

vis3D(X)

save('././GA/fval_1.mat','fval')
save('././GA/Details_1.mat','output')
save('././GA/Geom_1.mat','X')
save('././GA/pop_1.mat','population')
save('././GA/scores_1.mat','scores')

tEnd = toc(tstart)
