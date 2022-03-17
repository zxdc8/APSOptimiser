%////////CONSTRAINTS/////////
function [C, Ceq]= constraints(x)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);


%% Fuel Volume constraint
[VFus, VW, VP]=AreasVolumes(S,X,Z,dih);


%Requires function for Mach, Alt, S, CD0, k - func

%Calculate current volume of fuel tank required
%[Mf, Vf] = FuelMassEst(M,Alt,Swing,CD0,k);



%C(3) = Vf - (Vwing+Vfuse/2)

%% 
%Inequality Constraints
C(1)=S(2)-S(1);
C(2)=S(3)-S(2);

C(3)=S(2)+X(2)-72;  %Length Constraint
C(4)=S(3)+X(3)-72;  %Length Constraint

%fix
Vf = 300;

%Equality Constraints- Currently Trying Pax in Wings
Ceq(1)=Vf-VFus;     %Fuel Volume
Ceq(2)=VP-VW;      %Pax Volume
Ceq(3)=x(6)+x(7)-40; %Wingspan
end