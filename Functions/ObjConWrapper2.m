function [obj]=ObjConWrapper2(X)
%
%% make sure unfeasible solutions do not run
    %Calculate Wing Area
    [S,X2,Z,dih]=DesignToSXZ(X);
    
    %Inequality Constraints
    C2(1)=S(2)-S(1);     %Make sure wing tapers
    C2(2)=S(3)-S(2);

    C2(3)=S(2)+X2(2)-72;  %Length Constraint
    C2(4)=S(3)+X2(3)-72;  %Length Constraint
    C2(5)=X(6)+X(7)-40; %Wingspan
    
    C2(6) = X2(1) - X2(2); %enforce sweep
    C2(7) = X2(2) - X2(3); %enforce sweep
    
    if C2<=0 
        
        
    
%%
    key=randi([0 100000000])
    
    J=objectivepso(X,key);

    [C Ceq]=constraintspso(X,key);

    %Evaluate constraints and add to objective function if needed.
    
    %Scale Constraints
    C = C.*1e6;

    

    Cviolate=C(C>0);
    Cpenalty=sum(Cviolate);
    obj=J+Cpenalty;
    
    else
        C2 = C2.*1e6;
        Cviolate=C2(C2>0);
        Cpenalty=sum(Cviolate);
        J = 1e5;
        obj=J+Cpenalty;
        
        
    end
    
end