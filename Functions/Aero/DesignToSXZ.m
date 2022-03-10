%//CONVERT DESIGN VARIABLES TO X, S, Z
function [S,X,Z,dih]=DesignToSXZ(x)

    S(1:3)=x(1:3);
    X(1)= 0;
    X(2:3)=x(4:5);
    Z(1)= 0;
    Z(2)=Z(1)+x(6);
    Z(3)=Z(2)+x(7);
    dih=0;


end