%////////OBJECTIVE FUNCTION/////////
function f = objective(x)
%generate geometry

[filename,iter]=aeromodule(x);

%call avl
outname=AVLcall(filename,'w.run',iter);

%read data
force=importfile(outname);

CdCl=force(2)./force(1);



f=CdCl; %- this will be old I reckon

iterUpdate;

%% Performance part of objective function
%load into function Mach, Alt, Wing Area, Zero lift Drag, Induced Drag
%Outputs Fuel Weight and Fuel Volume - NOTE Fuel Volume used for
%constraints

%Example inputs
M = 0.7;
Alt = 38000;
S = 400;
CD0 = 0.014;
k = 0.05;

%[Mf, Vf] = FuelMassEst(M,Alt,S,CD0,k);


%f = Mf; - Load fuel mass as objective function

end