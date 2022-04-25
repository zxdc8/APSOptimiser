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
c2=0.4; %Social Coefficient (Swarm)
w=0.8;  %Inertia (keep going in same direction)


%Initialise Particle Swarm between upper and lower bounds
    for ii=1:length(LB)
        
            X(:,ii)=randi([LB(ii) UB(ii)],npts,1)

    end


%Set random velocities
V=rand(size(X))*10;

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
parfor (ii=1:size(X,1),4) %change 4 to 0 to debug
        
        pbest_obj(ii)=ObjConWrapper(pbest(ii,:));

end

%Find Global Optimimum
[M I]=min(pbest_obj);

gbest=pbest(I,:);
gbest_obj=pbest_obj(I);

for kk=1:nit
    
    %Update velocities
    r=rand(2,1);
    V=w*V+c1*r(1)*(pbest-X)+c2*r(2)*(gbest-X);

    X=X+V;
    
    %Set X to LB or UB if outside limits
    for qq=1:npts
         X(qq,X(qq,:)<LB)=LB(X(qq,:)<LB);
         X(qq,X(qq,:)>UB)=UB(X(qq,:)>UB);
    end

    %Work out X and V ranges
    
    for pp=1:size(X,2)
        
        Xrng(kk,pp)=range(X(:,pp))
        Vrng(kk,pp)=range(V(:,pp))

    end

    %Evaluation of objective function
    %%

    parfor (ii=1:size(X,1),4)
            
        obj(ii)=ObjConWrapper(X(ii,:));

    end

    pbest((pbest_obj >= obj),:)= X((pbest_obj >= obj),:);
    pbest_obj((pbest_obj >= obj))= obj((pbest_obj >= obj));

    %Find Global Optimimum
    [M I]=min(pbest_obj);
    
    gbest=pbest(I,:);
    gbest_obj=pbest_obj(I);

    Gcon(kk)=gbest_obj;
    
    
    

end

t=toc;
Xo=gbest;
Jo=gbest_obj;

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

figure
plot(1:nit,Gcon,'x-')
ylabel('J')
xlabel('iteration')

%Export some data for studies
DatOut(:,1)=Xcon;
DatOut(:,2)=Vcon;
DatOut(:,3)=Gcon;
DatOut(1:length(Xo),4)=Xo;
Datout(1,5)=t;

logfile=sprintf('Logging/n_%i_c1_%.1f_c2_%.1f_w_%.1f.csv',npts,c1,c2,w);
csvwrite(logfile,DatOut);





