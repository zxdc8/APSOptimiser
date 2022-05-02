close all
clear all

%Wingtip Scaling
X1=0:5:70;
X2=0:5:70;


rng('shuffle'); % shuffle the client
workerSeed = randi([0, 2^32-1]);
spmd
    stream = RandStream.create('mrg32k3a', ...
        'Seed', workerSeed, ...
        'NumStreams', numlabs, ...
        'StreamIndices', labindex);
    RandStream.setGlobalStream(stream);
end


for ii=1:length(X1)
    parfor jj=1:length(X2)

        X=[20.042808086131696,15,5.004365913034243, X1(ii), X2(jj),10.065899371081569,29.922740893508383]
        J(ii,jj)=ObjConWrapper(X);

    end
end

%%
%Save J Matrix
filename=('Logging/xvariationcs.csv')
csvwrite(filename,J);

%%
contourf(J,50)
colorbar

figure
surf(J)



