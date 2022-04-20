clear all
close all

load('GeometryOpt_IP.mat');
load('J_IP.mat');
load('Details_IP.mat');

%%
vis3D(X)

J = round(J);

title(['Fuel = ' num2str(J)"kg"]) 
