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

% key=randi([0 1000000]);

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
x0=[40 20 10 20 30 20 40];
% x0 = [20 15 10 17 45 26 14]; 

LB=[20 15 5 0 0 10 10];
UB=[40 40 40 20 40 35 40];

% iter=randi([0 1000000]);

%Write AVL case file and get filename, constraint values
% [filename]=aeromodule(x0,iter);

%Define Objective Function
objFun=@(x)ObjConWrapper2(x);



%GA Algorithm
options = optimoptions('patternsearch','Display','iter','MeshTolerance',1e-8,'FunctionTolerance',1e-2,'PlotFcn',{@psplotbestf,@psplotfuncount,@psplotmeshsize},'UseParallel',true,'UseCompleteSearch',true);

% options = optimoptions('patternsearch','Display','iter','InitialMeshSize',1,'MeshTolerance',1e-8,'FunctionTolerance',1e-2,'SearchFcn','searchlhs','PlotFcn',{@psplotbestf,@psplotfuncount,@psplotmeshsize},'Cache','on','UseVectorized',true,'UseCompleteSearch',true);

%Run Optimisation
[X,fval,exitflag,output]=patternsearch(objFun,x0,[],[],[],[],LB,UB,[],options);   



%AVLcall(filename,'mass_1.avl','w.run',iter);
fclose('all');

%% Output geometry and save file
saveas(gcf,'././PS/Step_2')

vis3D(X)
save('././PS/fval_2.mat','fval')
save('././PS/Details_2.mat','output')
save('././PS/Geom_2.mat','X')


tEnd = toc(tstart)
