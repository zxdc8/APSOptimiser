function [obj]=ObjConWrapper(X)

    key=randi([0 1000000]);
    
    J=objectivepso(X,key);

    [C Ceq]=constraintspso(X,key);

    %Evaluate constraints and add to objective function if needed.
    
    %Scale Constraints
    C(1:5)=C(1:5)*1e5; %geometry
    C(6)=C(6)*1e5;  %stability
    C(7:8)=C(7:8)*1e5; %geometry
    C(12)=C(12)*1e5;  %passenger volume

    

    Cviolate=C(C>0);
    Cpenalty=sum(Cviolate)
    obj=J+Cpenalty;
    
end