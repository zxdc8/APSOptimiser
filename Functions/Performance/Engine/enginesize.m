clear all
close all

PowerReq = 3020; %KW

SuppliedPower = 4745; %KW

ratio = PowerReq/SuppliedPower;


%% Weight Engine
Meng = PowerReq/3.2;%kg
Mmount = Meng*0.5;%kg
Mpylon = (Meng+Mmount)*0.2; %kg

Mtot = Meng+Mmount+Mpylon;

%% Prop Length

PropD = (PowerReq/(11*6*pi))^0.5; %m
PropR = PropD/2;%m

%% Dimensions

L = PropD*(ratio)^0.5;%m

LCGProp = PropD/2*(ratio)^0.5;%m from tip



%% Engine has to be mounted with CG on SPAR

WingPosLE = 16.8;%m from nose

Cr = 2.763; %m
Ce = Cr-(PropR+0.73)/14;

LGpos = WingPosLE+Ce*3/4

%Diameter to distance LE ratio of q400
PropRatio = 4.11/2.48;


WingendPos = WingPosLE+Ce

xpropLE = PropD/PropRatio;



EnginePropx = WingPosLE - xpropLE

EngineCGx = EnginePropx+LCGProp
EngineEndx = EnginePropx+L

LGPos = EngineEndx;

EnginePosy = 4.25;

%% Max cruise alt

rateclimb = 0;

V = 140; %m/s

W = 26500*9.81;

S=65; %m2

Powertot = PowerReq*2e3;

Cd0 = 0.0296;
K_Clean = 0.0259;

Drag = Powertot/V;

Alt = [20000:100:30000]'./ 3.281;

[~,~,~,rho] = atmosisa(Alt);

Cl = W./(0.5.*rho.*(V^2).*S);

D1 = (Cd0 + K_Clean.*Cl.^2).*0.5.*rho.*(V^2).*S;

