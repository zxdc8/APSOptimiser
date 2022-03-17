%////////CONSTRAINTS/////////
function [C, Ceq]= constraints(x)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);


A=0.5*(S(1)+S(2))*(Z(2));
At=sum(A)*2;

%Estimate volume (Area*Area*0.5)
V=At^2*0.5;

%Estimate Volume of a Passenger - IF WORKING FROM BWB 450 - 468 PAX
Vpas=2*0.5*0.5;
Npas=468;

VpasT=Vpas*Npas;


%% Fuel Volume constraint
%Estimate Volume of Fuel- INITIAL ESTIMATE BASED ON NOTHING - WILL MAYBE
%LOOK AT HAVING A VARIABLE CONSTRAINT? V_f<=V_favail - Discuss with Oli
VFuel=1000;

%Total Volume
VT=VFuel+VpasT;
=======
[VFus, VW, VP]=AreasVolumes(S,X,Z,dih);

%Estimate Volume of Fuel- RICKY!
VFuel=50;

%Requires function for Mach, Alt, S, CD0, k

%Calculate current volume of fuel tank required
%[Mf, Vf] = FuelMassEst(M,Alt,S,CD0,k);

%Function for current wing volume
%[Vwing Vfuse] = volumewing(x) %OLI 

%C(3) = Vf - (Vwing+Vfuse/2)

%% 
%Inequality Constraints
C(1)=S(2)-S(1);
C(2)=S(3)-S(2);

C(3)=S(2)+X(2)-72;  %Length Constraint
C(4)=S(3)+X(3)-72;  %Length Constraint

%Equality Constraints
Ceq(1)=VFuel-VW;     %Fuel Volume
Ceq(2)=VP-VFus;      %Pax Volume
Ceq(3)=x(6)+x(7)-40; %Wingspan
end