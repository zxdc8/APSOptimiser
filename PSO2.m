close all
clear all

%Set Parameters

tic
LB=[20 15 5 0 0 10 10];
UB=[40 40 40 40 50 35 40];

npts=240;    %no particles
nit=20;     %no iterations

%Set Swarm Parameters-These influence swarm behaviour
y1=1.49; %Cocignitive Coeffient (Hunt) Self adjustment weight
y2=1.49; %Social Coefficient (Swarm) Social adjustment weight
w=1.1;  %Inertia (keep going in same direction)



%Initialise Particle Swarm between upper and lower bounds
    for ii=1:length(LB)
        
%             X(:,ii)=linspace(LB(ii), UB(ii),npts);
              X(:,ii)=randi([LB(ii) UB(ii)],npts,1);
            
%             k(ii) = (UB(ii) - LB(ii));
%             V(:,ii) = randi([-k(ii) k(ii)],npts,1);
    end



%Set random velocities
V=rand(size(X))*10;

iter = 0;

%Set pbest
pbest=X;

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
parfor (ii=1:size(X,1)) %change 4 to 0 to debug
        
        pbest_obj(ii)=ObjConWrapper2(pbest(ii,:));

end

%Find Global Optimimum
[M I]=min(pbest_obj);

gbest=pbest(I,:);
gbest_init = gbest;
gbest_obj=pbest_obj(I);

Gcon(1)=gbest_obj;

X2 = cell(nit,1);
V2 = cell(nit,1);
%%
figure(1)
hold on
grid on
subplot(2,1,1)
plot(iter,gbest_obj,'r*')
b = "Best Function Value:";
b2 = num2str(round(gbest_obj,2));
b3 = join([b b2]);
title(b3)
xlabel('Iteration')

subplot(2,1,2)

bar(gbest)

title('Current Best Particle Solution')
xlabel('Variable')

drawnow

figure(2)
hold on
grid on
subplot(7,1,1)

title('Log range of particles by component')
drawnow
a(1) = "Range of particles for X(1)";
a(2) = "Range of particles for X(2)";
a(3) = "Range of particles for X(3)";
a(4) = "Range of particles for X(4)";
a(5) = "Range of particles for X(5)";
a(6) = "Range of particles for X(6)";
a(7) = "Range of particles for X(7)";


    figure(3)
    hold on
    for rr = 1:7
    plot(rr,X(:,rr),'bo')
    end
    title('Particles convergence')
    xlabel('X Variable')
    ylabel('Value')
    drawnow

    
%particleswarm initializes the stall counter
c = 0;

%% Main loop
for kk=1:nit
    iter = iter + 1;
    %Update velocities
    r1=rand(1,7);
    r2=rand(1,7);
    
    V=w*V+y1*r1.*(pbest-X)+y2*r2.*(gbest-X);
    
    X2{kk,1} = X;
    V2{kk} = V;
    X=X+V;
    
    
    %Set X to LB or UB if outside limits
    for qq=1:npts
        for qqq = 1:7
            if X(qq,qqq)<LB(qqq)
                X(qq,qqq) = LB(qqq);
                V(qq,qqq) = 0;                
            end
            
            if X(qq,qqq)>UB(qqq)
                X(qq,qqq) = UB(qqq);
                V(qq,qqq) = 0; 
            end
        end
    end

    %Work out X and V ranges
    
    for pp=1:size(X,2)
        
        Xrng(kk,pp)= max(X(:,pp))-min(X(:,pp));
        Vrng(kk,pp)= max(V(:,pp))-min(V(:,pp));

    end
        
        Xrng2 = log(Xrng);
    %Evaluation of objective function
    %%

    parfor (ii=1:size(X,1))
            
        obj(ii)=ObjConWrapper(X(ii,:));

    end
    
    %Output objective to data
    obj2 = obj';
    
    X2{kk}(:,8) = obj2;
    
    pbest((pbest_obj >= obj),:)= X((pbest_obj >= obj),:);
    pbest_obj((pbest_obj >= obj))= obj((pbest_obj >= obj));
    
%     for ss = 1:npts
%         if obj(ss)<= pbest_obj(ss)
%             
%             pbest_obj(ss) = obj(ss);
%             pbest(ss,:) = X(ss,:);
%         end
%     end

    %Find Global Optimimum
    [M I]=min(pbest_obj);
    
    gbest=pbest(I,:);
%     gbest2{kk} = gbest;
    gbest_obj=pbest_obj(I);


    if gbest_obj<Gcon(kk)
        
        flag = true;
        c = max(0,c-1);
        if c<2
            w = 2*w;
        end
        if c>4
            w = w/2;
        end
    else
        flag = false;
        c = c+1;        
    end
    
    Gcon(kk+1)=gbest_obj;
    

    
    
    figure(1)
    subplot(2,1,1)
    hold on
    plot(iter,gbest_obj,'r*')
    b = "Best Function Value:";
    b2 = num2str(round(gbest_obj,2));
    b3 = join([b b2]);
    title(b3)
    subplot(2,1,2)
    hold off
    bar(gbest)
    title('Current Best Particle Solution')
    xlabel('Variable')
    drawnow
    
    

    figure(2)
%     title('Log range of particles by component')
    
    for rr = 1:7
       
       subplot(7,1,rr)
       grid on
       plot(Xrng(:,rr),'k--')       
       title(a(rr))
    end
    drawnow
    
    clf(3)
    figure(3)
    hold on
    for rr = 1:7
    plot(rr,X(:,rr),'bo')
    end
    title('Particles convergence')
    xlabel('X Variable')
    ylabel('Value')
    drawnow
    
%     if c>8
%         break
%     end
    
    
end
%%
t=toc;
Xo=gbest;
Jo=gbest_obj;

Output.Geometry = Xo;
Output.Fuel = Jo;



for ii=1:kk
    Xcon(ii)=sum(Xrng(ii,:));
    Vcon(ii)=sum(Vrng(ii,:));
end


Range.X = Xcon;
Range.V = Vcon;

figure
plot(1:kk,Xcon,'x-')
hold all
plot(1:kk,Vcon,'x-')
legend('Summed Position Range','Summed Velocity Range')
grid on


FuncTolerance = Gcon(2:length(Gcon))-Gcon(1:length(Gcon)-1);

%% Save data

vis3D(Xo);

%Iteraiton and Particle position
save('././Logging/X_7.mat','X2')
save('././Logging/V_7.mat','V2')

%Final solution
save('././Logging/Output_7.mat','Output')

%Range of X values
save('././Logging/Ranges_7.mat','Range')







