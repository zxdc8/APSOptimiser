%////////AERO GEOMETRY WRAPPER/////////
function [filename,iter,At] = aeromodule(x,iter)

%Take design variables into a form the code likes
[S,X,Z,dih]=DesignToSXZ(x);

%Get iteration number
% iter=getIteration;
%iter = 1;

%Generate AVL Aero Input file
[filename,At]=AVLgen(S,Z,dih,X,iter);

end