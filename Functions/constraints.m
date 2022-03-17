%////////CONSTRAINTS/////////
function [C, Ceq]= constraints(x)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);

[VFus, VW, VP]=AreasVolumes(S,X,Z,dih);

%Estimate Volume of Fuel- RICKY!
VFuel=50;

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