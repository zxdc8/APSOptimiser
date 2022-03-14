%////////CONSTRAINTS/////////
function [C, Ceq]= constraints(x)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);

A=0.5*(S(1)+S(2))*(Z(2));
At=sum(A)*2;

%Inequality Constraints
C(1)=S(2)-S(1);
C(2)=S(3)-S(2);

%Equality Constraints
Ceq=-At+50;

end