%////////AERO GEOMETRY WRAPPER/////////
function [filename,At] = aeromodule(x,iter)

%Take design variables into a form the code likes
[S,X,Z,dih]=DesignToSXZ(x);

%Generate AVL Aero Input file
[filename,At]=AVLgen(S,Z,dih,X,iter);

end