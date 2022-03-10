%////////OBJECTIVE FUNCTION/////////
function f = objective(x)
%generate geometry

[filename,iter]=aeromodule(x);

%call avl
outname=AVLcall(filename,'w.run',iter);

%read data
force=importfile(outname);

CdCl=force(2)./force(1);

f=CdCl;

iterUpdate;

end