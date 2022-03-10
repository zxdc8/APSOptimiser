%////////AERO GEOMETRY WRAPPER/////////
function [filename,iter,At] = aeromodule(x)

%Take design variables into a form the code likes
[S,X,Z,dih]=DesignToSXZ(x);

% S(1)=20;
% S(2:3)=x(1:2);
% X(1)=0;
% X(2:3)=x(3:4);
% Z(1)=0;
% Z(2:3)=x(5:6);
% dih=x(7);


%Get iteration number
iter=getIteration;

%Generate AVL Aero Input file
[filename,At]=AVLgen(S,Z,dih,X,iter);

end