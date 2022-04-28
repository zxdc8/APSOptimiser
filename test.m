

% X = [20.0000   15.0000    10   0         0   10.0000   30.0000];

X = [30.0000   15.0000    5.7183   0.0000         0   10.0000   10.0000];



    [S,X2,Z,dih]=DesignToSXZ(X);
    
    %Inequality Constraints
    C2(1)=S(2)-S(1);     %Make sure wing tapers
    C2(2)=S(3)-S(2);

    C2(3)=S(2)+X2(2)-72;  %Length Constraint
    C2(4)=S(3)+X2(3)-72;  %Length Constraint
    C2(5)=X(6)+X(7)-40; %Wingspan
    
    C2(6) = X2(1) - X2(2); %enforce sweep
    C2(7) = X2(2) - X2(3); %enforce sweep

%     for (ii=1:size(X,1))
%           ii = 36;  
        obj_test=ObjConWrapper2(X);

%     end
    
    