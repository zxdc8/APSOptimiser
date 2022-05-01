close all
clear all

%Wingtip Scaling
Z1=10:2:40;
Z2=10:2:40;
ZC=Z1+Z2<40;

rng('shuffle'); % shuffle the client
workerSeed = randi([0, 2^32-1]);
spmd
    stream = RandStream.create('mrg32k3a', ...
        'Seed', workerSeed, ...
        'NumStreams', numlabs, ...
        'StreamIndices', labindex);
    RandStream.setGlobalStream(stream);
end


for ii=1:length(Z1)
    parfor jj=1:length(Z2)

        X=[20.109129956805420,15,5,0,40, Z1(ii), Z2(jj)];
        J(ii,jj)=ObjWrapper2(X);

    end
end

%%
%Save J Matrix
filename=('Logging/zvariation.csv')
csvwrite(filename,J);

%%
contourf(J,50)
colorbar



