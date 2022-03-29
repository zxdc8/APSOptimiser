function filename = AVLgenS(L,N,S,X,i,alpha)

%define wing sweep %CURRENTLY REDUNDANT
swp=30; %DEGREE 
swp=swp*pi/180;

%define wing dihedral
dih=10; %DEGREE
dih=dih*pi/180;

%Wing length and section number
%L=20;
%N=5;
z=0:L/(N-1):L;

%define length and x of each sectio (MUST MATCH N)
%S=[10 8 4 2 1];          %SCALE
%X=[0 2 3 10 15];          %DISPLACEMENT
A=0.5*(S(1:length(S)-1)+S(2:length(S)))*(z(2));
At=sum(A)*2;

%Define reference lengths, places
Lref=[At S(1) z(length(z))];
XYZref=[0.0 0.0 0.0];

%Define Mach, Cdp
M=0.5;
CDp=0;

%Define number of vortices and spacing etc
Nchord=12;  %number of chordwise vortices
Cspace=1;   %chordwise spacing, linear, cosine etc
Nspan=40;   %no spanwise vortices
Sspace=-1.5; %spanwise spacing

%create geometry file and create headers
filename=sprintf('case_%.0f.avl',i); %.avl
gfile=fopen(filename,'w');
fprintf(gfile,'test1\n%.2f\n0   0   0\n',M);
fprintf(gfile,'%.2f      %.2f      %.2f\n',Lref);
fprintf(gfile,'%.2f      %.2f      %.2f\n',XYZref);
fprintf(gfile,'%.2f\n',CDp);


%create wing surface
fprintf(gfile,'SURFACE\nWing\n');
fprintf(gfile,'%.2f    %.2f    %.2f    %.2f\n',Nchord,Cspace, Nspan,Sspace);
fprintf(gfile,'YDUPLICATE\n0\n');
fprintf(gfile,'ANGLE\n%.1f\n',alpha);

%construct wing
for ii=1:length(z)

    Xle=X(ii);
    Yle=z(ii);
    Zle=z(ii)*tan(dih);
    Chord=S(ii);
    Ainc=0;
    
    %define section properties
    fprintf(gfile,'SECTION\n');
    fprintf(gfile,'%.2f      %.2f  %.2f  %.2f   %.2f\n',Xle,Yle,Zle,Chord,Ainc);
    
    %define section camber line
    fprintf(gfile,'NACA\n2412\n');

end

copyfile( 'case_1.avl', 'case_1.txt' );

fclose(gfile);

f=0;

end




















