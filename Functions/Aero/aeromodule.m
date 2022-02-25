function ClCd = aeromodule(x)

%Set Parameters
N=3;  %No of sections

%Control Variables
%S=[20 10 2];
%X=[0 10 20];
%Z=[0 15 20];

%Take design variables into a form the code likes
S(1)=20;
S(2:3)=x(1:2);
X(1)=0;
X(2:3)=x(3:4);
Z(1)=0;
Z(2:3)=x(5:6);
dih=x(7);

%set iteration (should be looped)
filename='iteration.csv';
ifile=fopen(filename,'r');

LastIteration=table2array(readtable(filename));
iter=LastIteration;

fclose(ifile);

ifile=fopen(filename,'w');
fprintf(ifile,'%i',1+iter);
fclose(ifile);

%generate geometry
filename=AVLgen(N,S,Z,dih,X,iter);

%call avl
outname=AVLcall(filename,'w.run',iter);

%read data
force=importfile(outname);

ClCd=force(1)./force(2)



end