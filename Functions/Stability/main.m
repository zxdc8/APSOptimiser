close all
clear all

%Set Parameters
L=20;
N=5;

<<<<<<< HEAD
S=[11 7 6 3 2];
X=[0 3 5 9 13];

%set iteration (should be looped)
iter=1;
%Establish Weights of BWB components
Struc_Mass = 131375; %weight of wing structures
Payload_Mass = 105160; %weight of Passengers
Fuel_Mass = 390720; %weight of fuel @ take-off
=======
S=[10 8 4 2 1];
X=[0 2 3 10 15];

%set iteration (should be looped)
iter=1;
>>>>>>> abf7b881a385c434dba1d9ee54ad87c6fc9aad7b
    
alpha = 0;
target_cmtot = -0.01;
alpha_tol = 0.01; % 1% tolerance from target Cm

<<<<<<< HEAD
%generate geometry
filename = AVLgen(L,N,S,X,iter,alpha);
    
massfilename = MassDist(iter, Struc_Mass, Payload_Mass, Fuel_Mass); %Uses MassPoints & Foil_Integral functions to determine Mass distribution of Segments using previously made .avl file

% %call avl
% tot_forc=AVLcall(filename,massfilename,'w.run',iter);
% 
% 
% Case_Results = fscanf( fopen(tot_forc,'r'), '%s');   %fscanf(fileID, formatSpec)
% Cmtot = str2double( Case_Results([ strfind(Case_Results,'Cmtot=') + 6 :  strfind(Case_Results,'CZtot') - 1 ]) );
=======

%generate geometry
filename = AVLgen(L,N,S,X,iter,alpha);

massfilename = MassDist(iter); %Uses MassPoints & Foil_Integral functions to determine Mass distribution of Segments using previously made .avl file

%call avl
tot_forc=AVLcall(filename,massfilename,'w.run',iter);


Case_Results = fscanf( fopen(tot_forc,'r'), '%s');   %fscanf(fileID, formatSpec)
Cmtot = str2double( Case_Results([ strfind(Case_Results,'Cmtot=') + 6 :  strfind(Case_Results,'CZtot') - 1 ]) );

Cmtot




>>>>>>> abf7b881a385c434dba1d9ee54ad87c6fc9aad7b







