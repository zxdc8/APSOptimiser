clear all
close all
% %% DatumEngine Data Input
% %154 164
% %7 row difference
% % 289
% %B Q T
% 
% Sea Level 0ft M0.2 0.3 0.4 0.5 0.6
% DatumEngine{1} = readmatrix('EngineData.xlsx',...
%     'Range','C154:Q164');
% % 5000 ft M0.3 0.4 0.5 0.6 0.7
% DatumEngine{2} = readmatrix('EngineData.xlsx',...
%     'Range','C171:Q181');
% % 10000 ft M0.3 0.4 0.5 0.6 0.7
% DatumEngine{3} = readmatrix('EngineData.xlsx',...
%     'Range','C189:Q199');
% % 15000 ft M0.3 0.4 0.5 0.6 0.7
% DatumEngine{4} = readmatrix('EngineData.xlsx',...
%     'Range','C207:Q217');
% % 20000 ft M0.4 0.5 0.6 0.7
% DatumEngine{5} = readmatrix('EngineData.xlsx',...
%     'Range','F225:Q235');
% % 25000 ft M0.4 0.5 0.6 0.7
% DatumEngine{6} = readmatrix('EngineData.xlsx',...
%     'Range','F243:Q253');
% % 30000 ft M0.4 0.5 0.6 0.7 0.74
% DatumEngine{7} = readmatrix('EngineData.xlsx',...
%     'Range','F261:T271');
% % 35000 ft M0.4 0.5 0.6 0.7 0.74
% DatumEngine{8} = readmatrix('EngineData.xlsx',...
%     'Range','F279:T289');

%% Import Engine Data
DatumEngine=load("DatumEngine.mat");
DatumEngine=DatumEngine.DatumEngine;

%% 
Altitude=0:5000:35000;
Mach{1}=[0.2 0.3 0.4 0.5 0.6];
Mach{2}=[0.3 0.4 0.5 0.6 0.7];
Mach{3}=[0.3 0.4 0.5 0.6 0.7];
Mach{4}=[0.3 0.4 0.5 0.6 0.7];
Mach{5}=[0.4 0.5 0.6 0.7];
Mach{6}=[0.4 0.5 0.6 0.7];
Mach{7}=[0.4 0.5 0.6 0.7 0.74];
Mach{8}=[0.4 0.5 0.6 0.7 0.74];

%% Thrust Scaling

TScaleFactor=0.93;
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
        RC40 =[RC40; Altitude(i) Mach{i}(j) Thrust{i}(11,j) FC{i}(11,j)];
    end
end
RawEngineData.Max.Continuous=RC40;

%% Climb = RC 40
RawEngineData.Climb=RC40;

%% Cruise From RC 20, 0 until RC35 Rows 1 to 10
% From 15000 to 35000 ft (Can change the range using i variable below)
% for 15000 ft i=4, 5000 ft  i=1
    Cruise=[];
for i=4:size(DatumEngine,2)
    for j=1:1:(size(Thrust{i},2))
        for y=1:10
        Cruise =[Cruise; Altitude(i) Mach{i}(j) Thrust{i}(y,j) FC{i}(y,j)];
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
RawEngineData.Descent=Descent;

%% Diversion as Cruise at 20000 ft, M = 0.6 (specified in Airbus Task Spec
% RC 20 and 0
    Diversion=[];
    %20000ft i=5;
for i=5
    for j=1:1:(size(Thrust{i},2))
        for y=1:10
            if Mach{i}(j) == 0.6
                Diversion =[Diversion; Altitude(i) Mach{i}(j) Thrust{i}(y,j) FC{i}(y,j)];
            end
        end
    end
end
RawEngineData.Diversion=Diversion;

%%  Hold, Cruise data for 5000 ft Mach 0.3 (Available altitude and mach data)
% RC 20 and 0
    Hold=[];
    %5000ft i=2;
for i=2
    for j=1:1:(size(Thrust{i},2))
        for y=1:10
            if Mach{i}(j) == 0.3
                Hold =[Hold; Altitude(i) Mach{i}(j) Thrust{i}(y,j) FC{i}(y,j)];
            end
        end
    end
end
RawEngineData.Hold=Hold;

save("HED.mat","RawEngineData");
clear all
load("HED.mat","RawEngineData");