close all
clear all

%Wingtip Scaling
S1=20:2.5:70;
S2=15:2.5:70;


rng('shuffle'); % shuffle the client
workerSeed = randi([0, 2^32-1]);
spmd
    stream = RandStream.create('mrg32k3a', ...
        'Seed', workerSeed, ...
        'NumStreams', numlabs, ...
        'StreamIndices', labindex);
    RandStream.setGlobalStream(stream);
end


for ii=1:length(S1)
    parfor jj=1:length(S2)

        X=[S1(ii),S2(jj),5.004365913034243,9.740143774296792,27.757912051431890,10.065899371081569,29.922740893508383]
        J(ii,jj)=ObjConWrapper(X);

    end
end

%%
%Save J Matrix
filename=('Logging/svariationc.csv')
csvwrite(filename,J);

%%
contourf(J,50)
colorbar

figure
surf(J)



