function [obj]=ObjConWrapper2(X)

    key=randi([0 100000000])
    
    J=objectivepso(X,key);

    obj=J;

end