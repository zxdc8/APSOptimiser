close all
clear all

data=readmatrix('geoms.xlsx');

l=size(data,1);

for ii=1:l
    
    vis3D(data(:,ii));

end