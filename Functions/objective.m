%////////OBJECTIVE FUNCTION/////////
function [objFun] = objective(x)
%generate geometry

[filename,iter]=aeromodule(x);

%Take design variables into a form the code likes
[S,X,Z,dih]=DesignToSXZ(x);

%Get iteration number

iter=getIteration();

%Joe's Parameters
L=20;
N = 3; %Total no. of segment sides to make Wing modules 
Np = 2; %No. of segment sides dedicated to Passenger Cabin modules

%Establish Weights of BWB components
Struc_Mass = 131375; %weight of wing structures
Payload_Mass = 105160; %weight of Passengers
Fuel_Mass = 390720; %weight of fuel @ take-off
    
%Generate AVL Aero Input file
[filename,At]=AVLgen(S,Z,dih,X,iter);

%filename = AVLgen(L,N,S,X,iter,alpha);
[massfilepath, Area_Pass, Vol_Fuel] = MassDist(Np, iter, Struc_Mass, Payload_Mass, Fuel_Mass); %Uses MassPoints & Foil_Integral functions to determine Mass distribution of Segments using previously made .avl file

massfile=sprintf('mass_%.0f.mass',iter);
%call avl
outname=AVLcall(filename,massfile,'w.run',iter);

%read data

[CdCl, CD0, s, k, M]=ReadOutput(outname,x);

<<<<<<< HEAD

objFun = CdCl; %- this will be old I reckon
=======
%f=CdCl; %- this will be old I reckon
>>>>>>> da57431f0eca6f5b3e2a61fff76496693f4577e8

iterUpdate;

%% Performance part of objective function
%load into function Mach, Alt, Wing Area, Zero lift Drag, Induced Drag
%Outputs Fuel Weight and Fuel Volume - NOTE Fuel Volume used for
%constraints

%Example inputs

Alt = 38000;

[Mf, Vf] = FuelMassEst(M,Alt,s,CD0,k);


f = Mf;  %Load fuel mass as objective function

end