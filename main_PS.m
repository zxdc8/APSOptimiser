%////////MAIN FILE - RUN THIS/////////
fclose('all');
close all
clear all

% delete('././TIC/*.txt');

echo off all
tstart = tic;
%set iteration file-workaround
filename='iteration.csv';
ifile=fopen(filename,'w');
fprintf(ifile,'1');

fclose(ifile);

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
% x0 = [20 15 10 17 45 26 14]; 

LB=[20 15 10 0 0 10 10];
UB=[72 72 72 72 72 35 40];



%Write AVL case file and get filename, constraint values
[filename,iter,At]=aeromodule(x0);

%Define Objective Function
objFun=@(x)objective(x);


%PS Algorithm
% options = optimoptions('patternsearch','Display','iter','InitialMeshSize',1,'MeshTolerance',1e-10,'SearchFcn','searchlhs','FunctionTolerance',1e-2,'AccelerateMesh',true,'PlotFcn',{@psplotbestf,@psplotfuncount,@psplotmeshsize},'Cache','on','UseCompleteSearch',true);

options = optimoptions('patternsearch','Display','iter','MeshTolerance',1e-12,'AccelerateMesh',true,'SearchFcn','GPSPositiveBasisNp1','PollMethod','GPSPositiveBasis2N','FunctionTolerance',1e-12,'StepTolerance',1e-12,'PlotFcn',{@psplotbestf,@psplotfuncount,@psplotmeshsize},'Cache','on');

%Run Optimisation
[X,fval,exitflag,output]=patternsearch(objFun,x0,[],[],[],[],LB,UB,@constraints,options);   



%AVLcall(filename,'mass_1.avl','w.run',iter);
fclose('all');

%% Output geometry and save file
saveas(gcf,'././PS/Step_6')

vis3D(X)
save('././PS/fval_6.mat','fval')
save('././PS/Details_6.mat','output')
save('././PS/Geom_6.mat','X')
% save('././PS/pop_1.mat',population)
% save('././PS/scores_1.mat',scores)

tEnd = toc(tstart)
