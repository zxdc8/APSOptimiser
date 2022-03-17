%////////GENERATES AVL CASE FILE/////////////

function [filename,At] = AVLgen(S,Z,dih,X,i)

%Redefine dihedral in radians
dih=dih*pi/180;

%Calculate planform area
A=0.5*(S(1:length(S)-1)+S(2:length(S))).*(Z(1:length(Z)-1));
At=sum(A)*2;

%Define reference lengths, places
Lref=[At S(1) 2*Z(length(Z))];
XYZref=[0.0 0.0 0.0];

%Define Mach, Cdp
M=0.7;
CDp=0.016;
CD0=0.01;

%Define CL
CL=LiftCalc(M,At,CD0)

%Define number of vortices and spacing etc
Nchord=12;  %number of chordwise vortices
Cspace=1;   %chordwise spacing, linear, cosine etc
Nspan=20;   %no spanwise vortices
Sspace=-1.5; %spanwise spacing

%create geometry file and create headers
pth='././Inputs/AVLcases';
filename=sprintf('case_%.0f.avl',i);
gfile=fopen(fullfile(pth,filename),'w');
fprintf(gfile,'Cruise\n%.2f\n0   0   0\n',M);
fprintf(gfile,'%.2f      %.2f      %.2f\n',Lref);
fprintf(gfile,'%.2f      %.2f      %.2f\n',XYZref);
fprintf(gfile,'%.2f\n',CDp);

%create wing surface
fprintf(gfile,'SURFACE\nWing\n');
fprintf(gfile,'%.2f  %.2f\n',Nchord,Cspace);
fprintf(gfile,'YDUPLICATE\n0\n');

%construct wing
for ii=1:length(Z)

    Xle=X(ii);
    Yle=Z(ii);
    Zle=Z(ii)*tan(dih);
    Chord=S(ii);
    Ainc=0;
    
    %define section properties
    fprintf(gfile,'SECTION\n');
    fprintf(gfile,'%.2f      %.2f  %.2f  %.2f  %.2f  %.2f  %.2f\n ',Xle,Yle,Zle,Chord,Ainc, Nspan,Sspace);
    
    %define section camber line
    fprintf(gfile,'NACA\n2412\n');

end

fclose(gfile);

end




















