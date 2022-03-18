%////////CONSTRAINTS/////////
function [C, Ceq]= constraints(x)

%Calculate Wing Area
[S,X,Z,dih]=DesignToSXZ(x);


%% Fuel Volume constraint
[VFus, VW, VP]=AreasVolumes(S,X,Z,dih);

iter=getIteration();

outname=sprintf('out_%i.txt',iter)

%Requires function for Mach, Alt, S, CD0, k - func

[CdCl, CD0, s, k, M]=ReadOutput(outname,x);

Alt=38000;
M=0.7; %Placeholder

%Calculate current volume of fuel tank required
[Mf, Vf] = FuelMassEst(M,Alt,s,CD0,k);

%OR USE FIXED FUEL
%Vf = 100;


%C(3) = Vf - (Vwing+Vfuse/2)

%% 
%Inequality Constraints
C(1)=S(2)-S(1);
C(2)=S(3)-S(2);

C(3)=S(2)+X(2)-72;  %Length Constraint
C(4)=S(3)+X(3)-72;  %Length Constraint
C(5)=x(6)+x(7)-40; %Wingspan


%Equality Constraints
Ceq(1)=Vf-VW-((1/3)*VFus);     %Fuel Volume
Ceq(2)=VP-(2/3)*VFus;      %Pax Volume

end