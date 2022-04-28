function [obj]=ObjConWrapper(X)

    key=randi([0 100000000])
    
    J=objectivepso(X,key);

    [C Ceq]=constraintspso(X,key);

    %Evaluate constraints and add to objective function if needed.
    
    %Scale Constraints
    C = C.*1e8; %geometry


    

    Cviolate=C(C>0);
    Cpenalty=sum(Cviolate)
    obj=J+Cpenalty;
    
end