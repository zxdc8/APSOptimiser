%////////CONSTRAINTS/////////
function [C, Ceq] = constraints(x)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);


%Read out Constrains Input Text file
pth='././';
% pth = 'C:/Users/Joe/OneDrive - University of Bristol/Documents/GitHub/APSOptimiser'; %/\/\/\/\
confilename=sprintf('Constraint_Input.txt');
confid = fopen(fullfile(pth,confilename)); %Opens Constraint Input file
Np = str2double(fgetl(confid)); %Read out each text file line in order and assign to subsequent variable
Struc_Mass = str2double(fgetl(confid));
Payload_Mass = str2double(fgetl(confid));
Fuel_Mass = str2double(fgetl(confid));

%% Fuel Volume constraint
% [VFus, VW, VP]=AreasVolumes(S,X,Z,dih);

iter=getIteration();
outname=sprintf('Out_Force_%i.txt',iter-1);

           
%Requires function for Mach, Alt, S, CD0, k - func

[CdCl, CD0, s, k, M]=ReadOutput(outname,x);

Alt=38000;
M=0.7; %Placeholder

%Calculate current volume of fuel tank required
[Mf, Vf] = FuelMassEst(M,Alt,s,CD0,k);


%% Joes code
Np = 2;

[massfilename, Area_Pass, Vol_Fuel] = MassDist(Np, iter-1, Struc_Mass, Payload_Mass, Mf);
Area_Pass; %Area of Passenger module floor, used to determine if there is enough floor space for all passengers ...
           %Given the height of the aerofoils for the passeneger modules, assume at all points there is enough ...
           %height space for passengers to sit
Vol_Fuel; %Volume of Fuel module, should be multiplied by a factor to account for structures and sub-systems that take up volume in this moudle

%Express area of passengers required
Ap=450*0.5*0.5*1.2;



%Stability Part
target_cmtot = -0.01;
alpha_tol = 1.01; % 1% tolerance from target Cm

Case_Results = fscanf( fopen(outname,'r'), '%s');   %fscanf(fileID, formatSpec)
Cmtot = str2double( Case_Results([ strfind(Case_Results,'Cmtot=') + 6 :  strfind(Case_Results,'CZtot') - 1 ]) );


%% 
%Inequality Constraints
C(1)=S(2)-S(1);     %Make sure wing tapers
C(2)=S(3)-S(2);

C(3)=S(2)+X(2)-72;  %Length Constraint
C(4)=S(3)+X(3)-72;  %Length Constraint
C(5)=x(6)+x(7)-40; %Wingspan

C(6)=Cmtot*alpha_tol-target_cmtot;  %Longitudinal stability

%Equality Constraints
%Ceq=[]
Ceq(1)=Vf-Vol_Fuel;     %Fuel Volume
Ceq(2)=Ap-Area_Pass;      %Pax Volume

end