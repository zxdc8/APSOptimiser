close all
clear all

%Wingtip Scaling
X1=0:30;
X2=0:30;


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

        X=[20 15 10 X1(ii) X2(jj) 10 30];
        J(ii,jj)=ObjWrapper(X);

    end
end

%%
%Save J Matrix
filename=('Logging/xvariation.csv')
csvwrite(filename,J);

%%
contourf(J,50)
colorbar

figure
surf(J)



