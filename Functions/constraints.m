%////////CONSTRAINTS/////////
function [C, Ceq] = constraints(x, Np, Struc_Mass, Payload_Mass, Fuel_Mass)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);


%% Fuel Volume constraint
% [VFus, VW, VP]=AreasVolumes(S,X,Z,dih);

iter=getIteration();
outname=sprintf('Out_Force_%i.txt',iter-1);

Np
iter
Struc_Mass
Payload_Mass
Fuel_Mass

[massfilename, Area_Pass, Vol_Fuel] = MassDist(Np, iter, Struc_Mass, Payload_Mass, Fuel_Mass);
Area_Pass; %Area of Passenger module floor, used to determine if there is enough floor space for all passengers ...
           %Given the height of the aerofoils for the passeneger modules, assume at all points there is enough ...
           %height space for passengers to sit
Vol_Fuel; %Volume of Fuel module, should be multiplied by a factor to account for structures and sub-systems that take up volume in this moudle
           
%Requires function for Mach, Alt, S, CD0, k - func

[CdCl, CD0, s, k, M]=ReadOutput(outname,x);

Alt=38000;
M=0.7; %Placeholder

%Calculate current volume of fuel tank required
[Mf, Vf] = FuelMassEst(M,Alt,s,CD0,k);

%OR USE FIXED FUEL
%Vf = 400;


%C(3) = Vf - (Vwing+Vfuse/2)

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
Ceq(1)=Vf-VW-((1/3)*VFus);     %Fuel Volume
Ceq(2)=VP-(2/3)*VFus;      %Pax Volume

end