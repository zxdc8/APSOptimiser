%////////CONSTRAINTS/////////
function [C, Ceq]= constraints(x)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);

A=0.5*(S(1)+S(2))*(Z(2));
At=sum(A)*2;

%Estimate volume (Area*Area*0.5)
V=At^2*0.5;

%Estimate Volume of a Passenger
Vpas=2*0.5*0.5;
Npas=200;

VpasT=Vpas*Npas;

%Estimate Volume of Fuel- RICKY!
VFuel=704;

%Total Volume
VT=VFuel+VpasT;

%Inequality Constraints
C(1)=S(2)-S(1);
C(2)=S(3)-S(2);

%Equality Constraints
Ceq=-VT+V;

end