close all
clear all

%Set Parameters

tic
LB=[20 15 10 0 0 10 10];
UB=[40 35 20 40 72 30 30];

npts=40;    %no particles
nit=20;     %no iterations

%Set Swarm Parameters-These influence swarm behaviour
c1=0.7; %Cocignitive Coeffient (Hunt)
c2=0.5; %Social Coefficient (Swarm)
w=0.8;  %Inertia (keep going in same direction)


%Initialise Particle Swarm between upper and lower bounds
    for ii=1:length(LB)
        
            X(:,ii)=randi([LB(ii) UB(ii)],npts,1);

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
        
        pbest_obj(ii)=ObjConWrapper(pbest(ii,:));

end

%Find Global Optimimum
[M I]=min(pbest_obj);

gbest=pbest(I,:);
gbest_init = gbest;
gbest_obj=pbest_obj(I);

X2 = cell(nit,1);
V2 = cell(nit,1);
%%
figure(1)
hold on
grid on
subplot(2,1,1)
plot(iter,gbest_obj,'r*')
title('Function Value (Fuel) [kg]')
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


%%
for kk=1:nit
    iter = iter + 1;
    %Update velocities
    r=rand(2,1);
    V=w*V+c1*r(1)*(pbest-X)+c2*r(2)*(gbest-X);
    
    X2{kk,1} = X;
    V2{kk} = V;
    X=X+V;
    
    
    %Set X to LB or UB if outside limits
    for qq=1:npts
         X(qq,X(qq,:)<LB)=LB(X(qq,:)<LB);
         X(qq,X(qq,:)>UB)=UB(X(qq,:)>UB);
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

    %Find Global Optimimum
    [M I]=min(pbest_obj);
    
    gbest=pbest(I,:);
%     gbest2{kk} = gbest;
    gbest_obj=pbest_obj(I);

    Gcon(kk)=gbest_obj;
    
    figure(1)
    subplot(2,1,1)
    hold on
    plot(iter,gbest_obj,'r*')
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
    
    
end

t=toc;
Xo=gbest;
Jo=gbest_obj;

Output.Geometry = Xo;
Output.Fuel = Jo;

Range.X = Xrng;
Range.V = Vrng;

for ii=1:nit
    Xcon(ii)=sum(Xrng(ii,:))
    Vcon(ii)=sum(Vrng(ii,:))
end

figure
plot(1:nit,Xcon,'x-')
hold all
plot(1:nit,Vcon,'x-')
legend('Summed Position Range','Summed Velocity Range')
grid on


FuncTolerance = Gcon(2:length(Gcon))-Gcon(1:length(Gcon)-1);

%% Save data

%Iteraiton and Particle position
save('././Logging/X_1.mat',X2)
save('././Logging/V_1.mat',V2)

%Final solution
save('././Logging/Output_1.mat',Output)

%Range of X values
save('././Logging/Ranges_1.mat',Range)







