%////////MAIN FILE - RUN THIS/////////
fclose('all');
close all
clear all

% delete('././TIC/*.txt');

echo off all
tstart = tic;


LB=[20 15 5 0 0 10 10];
UB=[40 40 40 20 40 35 40];


%Define Objective Function
objFun=@(x)ObjConWrapper2(x);
% constFun = @(x)constraintspso2(x,key);


%% GA Algorithm
options = optimoptions('ga','Display','iter','FunctionTolerance',1e-2,'PopulationSize',200,'MaxGenerations',60,'PlotFcn',{@gaplotbestf,@gaplotrange,@gaplotexpectation,@gaplotstopping},'UseParallel',true);

%Hybrid Function - Active set

% fminconOptions = optimoptions(@fmincon,'Algorithm','active-set','PlotFcn',{'optimplotfval','optimplotx'},'UseParallel',true);
% options = optimoptions(options,'HybridFcn',{@fmincon, fminconOptions});

%Run Optimisation
[X,fval,exitflag,output,population,scores]=ga(objFun,7,[],[],[],[],LB,UB,[],options);   


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
