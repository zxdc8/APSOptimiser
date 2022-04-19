function [CdCl, CD0, S, k, M]   =   ReadOutput(outname,x)

force=importfile(outname);

oswald=importe(outname);

SM=importfileSM(outname);

%Glide Ratio
CdCl=force(2)./force(1);

%CD0
CD0=force(2)-oswald(1);

%E
e=oswald(2);

%S
S=SM(1);

%Aspect ratio
AR=(((x(6)+x(7))*2).^2)/S;

%Span efficiency factor
k=1/(pi*e*AR);

%MACH
M=SM(2); %Broken ATM
M=0.7;
