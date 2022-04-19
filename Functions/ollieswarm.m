function [X,J]=ollieswarm(objective, x0, LB, UB, constraint,npts)


    wid=npts^(1/length(LB))
    %Initialise Particle Swarm between upper and lower bounds
    for ii=1:length(LB)
        
        X(ii,:)=LB(ii):(UB(ii)-LB(ii))/wid:UB(ii)

    end
    
    %Set random velocities
    V=rand(size(X))*5


end