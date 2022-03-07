clear all
close all

S = 65;%m2

MTOW = 27000*9.81; %N

%angle%
thetap = 2.4;
theta = atan(thetap/100);

% drag calc
Cd0 = 0.0920;
K = 0.0303;

% Cd0 = 0.0296;
% K = 0.0259;

%V2 speed at TO
V2 = 70; %m/s

L = MTOW*cos(theta);%N

%Cl required at T/O
Clto = L/(0.5*1.225*V2^2*S);

%Drag polar
Cdtot = Cd0+K*Clto^2;
Dtot = Cdtot*0.5*1.225*V2^2*S; %N

%Thrust Required 
Treq = (Dtot+MTOW*sin(theta));

%Power required
Preq = Treq*V2/1000


%P available 3020
Pav = 3020*1000*1;

Tav = Pav/V2;

thetaav = asin((Tav-Dtot)/MTOW);

thetap2 = tan(thetaav)*100




