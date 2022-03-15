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

%Estimate Volume of Fuel- INITIAL ESTIMATE BASED ON NOTHING - WILL MAYBE
%LOOK AT HAVING A VARIABLE CONSTRAINT? V_f<=V_favail - Discuss with Oli
VFuel=1000;

%Total Volume
VT=VFuel+VpasT;

%Inequality Constraints
C(1)=S(2)-S(1);
C(2)=S(3)-S(2);

%Equality Constraints
Ceq=-VT+V;

end