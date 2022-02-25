close all
clear all

%Set Parameters
L=20; %span
N=3;  %No of sections

%Control Variables
S=[20 10 2];
X=[0 10 20];
Z=[0 15 20];
dih=5;  %dihedral in degrees

%set iteration (should be looped)
iter=1;

%generate geometry
filename=AVLgen(L,N,S,Z,dih,X,iter);

%call avl
outname=AVLcall(filename,'w.run',iter);

%read data
force=importfile(outname)

