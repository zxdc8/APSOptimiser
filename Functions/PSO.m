function [X,J]=PSO(x0, LB, UB,npts)

   

    wid=npts^(1/length(LB));
    %Initialise Particle Swarm between upper and lower bounds
    for ii=1:length(LB)
        
        X(:,ii)=LB(ii):(UB(ii)-LB(ii))/npts:UB(ii);

    end

    %Better method just do it randomly, stupid

    %X=rand(npts,length(LB))
    
    %Set random velocities
    V=rand(size(X))*5;
    
    %Set pbest
    pbest=X;
    
    %delete(gcp('nocreate'))
    % workers initialization:
        
    %parpool(4);
    

    rng('shuffle'); % shuffle the client
    workerSeed = randi([0, 2^32-1]);
    spmd
        stream = RandStream.create('mrg32k3a', ...
            'Seed', workerSeed, ...
            'NumStreams', numlabs, ...
            'StreamIndices', labindex);
        RandStream.setGlobalStream(stream);
    end
    
    %Inital Evaluation of objective function
    parfor (ii=1:size(X,1),4) %change 4 to 0 to debug
            
            pbest_obj(ii)=ObjConWrapper(pbest(ii,:));

    end
    
    %Find Global Optimimum
    [M I]=min(pbest_obj);
    
    gbest=pbest(I,:);
    gbest_obj=pbest_obj(I);

    for kk=1:5
    %Set Swarm Parameters
        
        c1=0.1;
        c2=0.1;
        w=0.8;
    
        %Update velocities
        r=rand(2,1);
        V=w*V+c1*r(1)*(pbest-X)+c2*r(2)*(gbest-X);
    
        X=X+V;

        %Evaluation of objective function
        
        parfor (ii=1:size(X,1),4)
                
            obj(ii)=ObjConWrapper(X(ii,:));
    
        end

        pbest((pbest_obj >= obj),:)= X((pbest_obj >= obj),:);
        pbest_obj((pbest_obj >= obj))= obj((pbest_obj >= obj));

        %Find Global Optimimum
        [M I]=min(pbest_obj);
        
        gbest=pbest(I,:);
        gbest_obj=pbest_obj(I);
    
        end

        X=gbest;
        J=gbest_obj;

end