function [obj]=ObjConWrapper(X)

    key=randi([0 100000000])
    
    J=objectivepso(X,key);

%     [C Ceq]=constraintspso(X,key);

    %Evaluate constraints and add to objective function if needed.
    
%     %Scale Constraints
%     C(1:5)=C(1:5)*1e5; %geometry
%     C(6)=C(6)*2e6;  %stability
%     C(7:8)=C(7:8)*2e6 %geometry
%     C(12)=C(12)*10  %passenger volume
% 
%     
% 
%     Cviolate=C(C>0);
%     Cpenalty=sum(Cviolate)
    obj=J;
    
end