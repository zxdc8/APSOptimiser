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

        X=[20.042808086131696,15,5.004365913034243,9.740143774296792,27.757912051431890,Z1(ii), Z2(jj)];
        J(ii,jj)=ObjConWrapper(X);

    end
end

%%
%Save J Matrix
filename=('Logging/zvariationc.csv')
csvwrite(filename,J);

%%
contourf(J,50)
colorbar




