close all
clear all

%Wingtip Scaling
ST=5:0.5:15;



rng('shuffle'); % shuffle the client
workerSeed = randi([0, 2^32-1]);
spmd
    stream = RandStream.create('mrg32k3a', ...
        'Seed', workerSeed, ...
        'NumStreams', numlabs, ...
        'StreamIndices', labindex);
    RandStream.setGlobalStream(stream);
end


    parfor jj=1:length(ST)

        X=[20.042808086131696,15,ST(jj),9.740143774296792,27.757912051431890,10.065899371081569,29.922740893508383]
        J(jj)=ObjConWrapper(X);

    end

%%
%Save J Matrix
filename=('Logging/Tvariationc.csv')
csvwrite(filename,J);

%%
figure
plot(ST,J)
grid on


