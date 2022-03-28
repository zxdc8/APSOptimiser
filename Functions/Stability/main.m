close all
clear all

%Set Parameters
L=20;
N=5;

S=[10 8 4 2 1];
X=[0 2 3 10 15];

%set iteration (should be looped)
iter=1;
    
alpha = 0;
target_cmtot = -0.01;
alpha_tol = 0.01; % 1% tolerance from target Cm


%generate geometry
filename = AVLgen(L,N,S,X,iter,alpha);

massfilename = MassDist(iter); %Uses MassPoints & Foil_Integral functions to determine Mass distribution of Segments using previously made .avl file

%call avl
tot_forc=AVLcall(filename,massfilename,'w.run',iter);


Case_Results = fscanf( fopen(tot_forc,'r'), '%s');   %fscanf(fileID, formatSpec)
Cmtot = str2double( Case_Results([ strfind(Case_Results,'Cmtot=') + 6 :  strfind(Case_Results,'CZtot') - 1 ]) );

Cmtot











