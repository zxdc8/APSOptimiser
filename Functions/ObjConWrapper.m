function [obj]=ObjConWrapper(X)

    key=randi([0 1000000])
    
    J=objectivepso(X,key);

    [C Ceq]=constraintspso(X,key);

    %Evaluate constraints and subtract to objective function if needed.
    
    Cviolate=C(C>0);
    Cpenalty=sum(Cviolate)*1000;
    obj=J-Cpenalty;
    
end