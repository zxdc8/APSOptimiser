

load('GeometryOpt_AS1.mat');
load('J_AS1.mat');
load('Details_AS1.mat');

openfig('Step_AS1')

%%
vis3D(X)

J = round(J);
a = string(['Fuel = ']);
b = num2str(J);
c = string(['kg']);

a = join([a b c]);

title(a) 
