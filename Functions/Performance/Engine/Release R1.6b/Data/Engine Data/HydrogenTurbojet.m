function RawEngineData = HydrogenTurbojet
%UBB65Data provides raw engine data for the Hydrogen Turboprop scaled with
%a thrust scale factor
%
% Engine data for Diversion, Climb, Descent, Cruise, Hold and Approach
%
% FlH2y 2021
% 
% Data provided as [altitude [ft], Mach number [-], Thrust [N], Fuel Flow [kg/hr] ]

%% Import Engine Data
DatumEngine = load("DatumEngineJet.mat");
DatumEngine = DatumEngine.DatumEngine;



%% 
Altitude=[0 10000 20000 25000 31000 35000 39000 41000];
Mach{1}=[0.25 0.35 0.45 ];
Mach{2}=[0.35 0.45 0.65 0.75];
Mach{3}=[0.45 0.65 0.75 0.80 0.82 0.84];
Mach{4}=[0.45 0.65 0.75 0.80 0.82 0.84];
Mach{5}=[0.65 0.75 0.80 0.82 0.84];
Mach{6}=[0.65 0.75 0.80 0.82 0.84];
Mach{7}=[0.65 0.75 0.80 0.82 0.84];
Mach{8}=[0.65 0.75 0.80 0.82 0.84];


RC = cell(1,8);

RC{1} = [20
0
0
0
0
0
0
0
0
0
0
0
35
40];
RC{2} = [20
0
0
0
0
35
40];
RC{3} = [20
0
0
0
0
35
40];
RC{4} = [20
0
0
0
0
35
40];
RC{5} = [20
0
0
0
0
0
0
35
40];
RC{6} = [20
0
0
0
0
0
0
35
40];
RC{7} = [20
0
0
0
0
0
0
35
40];
RC{8} = [20
0
0
0
0
0
0
35
40];


%% Thrust Scaling
%
% MODIFY THIS VALUE FOR THRUST SCALE
TScaleFactor= 1.2;
%
%
disp(['Using Thrust Scale Factor of ',num2str(TScaleFactor)]);
% Thrust (N)
for i=1:size(DatumEngine,2)
    temp=[];
    for j=1:3:(size(DatumEngine{i},2)-2)
        temp =[temp TScaleFactor.*DatumEngine{i}(:,j)];
        Thrust{i}=[temp];
    end
end
% SFC (kg/hr/N)
for i=1:size(DatumEngine,2)
    temp=[];
    for j=3:3:(size(DatumEngine{i},2))
        temp =[temp DatumEngine{i}(:,j)];
        SFC{i}=[temp];
    end
end
% Fuel Consumption (kg/hr)
for i=1:size(DatumEngine,2)
    FC{i}=Thrust{i}.*SFC{i};
end

%% Max Continous = RC40 Max Climb = Row 11 at each altitude
    RC40=[];
for i=1:size(DatumEngine,2)
    for j=1:1:(size(Thrust{i},2))
        RC40 =[RC40; Altitude(i) Mach{i}(j) Thrust{i}(end,j) FC{i}(end,j)];
    end
end
RawEngineData.Max.Continuous=RC40;

%% Climb = RC 40
RawEngineData.Climb=RC40;

%% Cruise From RC 20, 0 until RC35 Rows 

    Cruise=[];
for i=1:size(DatumEngine,2)
    for j=1:1:(size(Thrust{i},2))
        for y=1:size(Thrust{i},1)
            if RC{i}(y) == 0
                Cruise =[Cruise; Altitude(i) Mach{i}(j) Thrust{i}(y,j) FC{i}(y,j)];
            end
        end
    end
end
RawEngineData.Cruise=Cruise;

%% Descent = RC20
    Descent=[];
for i=1:size(DatumEngine,2)
    for j=1:1:(size(Thrust{i},2))
        for y=1:1
        Descent =[Descent; Altitude(i) Mach{i}(j) Thrust{i}(y,j) FC{i}(y,j)];
        end
    end
end

%%
RawEngineData.Descent=Descent;

RawEngineData.Hold = RawEngineData.Cruise;

RawEngineData.Diversion = RawEngineData.Cruise;

save("HED.mat","RawEngineData");
clear all
load("HED.mat","RawEngineData");
end