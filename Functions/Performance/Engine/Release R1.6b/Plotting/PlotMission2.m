function PlotMission2(Mission)
% PlotMission2(Mission) for MATALB before R2015
% Plot time, range,fuel mass and aircraft mass for a mission
% 
% Created by D Rezgui 2017
% Copyright: University of Bristol

ph = {'01 Start'
    '02 Taxi-out'
    '03 Take-off'
    '04 Climb'
    '05 Cruise'
    '06 Descent'
    '07 Approach'
    '08 Taxi-in'
    '09 % policy'
    '10 Cont cruise'
    '11 Overshoot'
    '12 Div climb'
    '13 Div cruise'
    '14 Div descent'
    '15 Hold'
    '16 Div approach'}';

% Mission Climb Performance
figure(1)
subplot(1,4,1); plot(Mission.Data.Range_nm, Mission.Data.h_ft/1000); hold on;grid on; xlabel('Range [nm]'); ylabel('Altitude [1000 ft]')
subplot(1,4,2); plot(Mission.Data.FuelBurn, Mission.Data.h_ft/1000); hold on;grid on; xlabel('Fuel Burn [kg]'); ylabel('Altitude [1000 ft]')
% title('Mission Climb Performance')
subplot(1,4,3); plot(Mission.Data.time_min, Mission.Data.h_ft/1000); hold on;grid on; xlabel('Time [min]'); ylabel('Altitude [1000 ft]')
subplot(1,4,4); plot(Mission.Data.ROC_fpm, Mission.Data.h_ft/1000); hold on;grid on; xlabel('ROC [fpm]'); ylabel('Altitude [1000 ft]')
pos = get(gcf,'Position').*[1 1 1.5 1];
set(gcf,'Position',pos,'Name', 'Mission Climb Performance')

% figure(11)
% subplot(1,3,1); plot(Mission.Data.M, Mission.Data.h_ft/1000); hold on;grid on; xlabel('Mach Number [-]'); ylabel('Altitude [1000 ft]')
% subplot(1,3,2); plot(Mission.Data.CAS_kts, Mission.Data.h_ft/1000); hold on;grid on; xlabel('CAS [kts]'); ylabel('Altitude [1000 ft]')
% title('Mission Climb Performance')
% subplot(1,3,3); plot(Mission.Data.ROC_fpm, Mission.Data.h_ft/1000); hold on;grid on; xlabel('ROC [fpm]'); ylabel('Altitude [1000 ft]')
% set(gcf,'Position',[608.00 280.00 1220.00 420.00])

% Plot
figure(2);
% Time
% subplot(2,2,1);
h=gcf;
if ~isempty(get(h,'Children'))
    BarWidth = h.Children.Children(1).BarWidth*0.8;
    val1      =  h.Children.Children(1).FaceColor*0.9;
    val2      =  h.Children.Children(1).EdgeColor*0.9;
else
    BarWidth = 0.8;
    val1      = [0,1,0];
    val2      = [0,0,1];
end
title('Mission Time [minutes]');
hold on;
grid on;
bar(Mission.Time,BarWidth,'FaceColor',val1,'EdgeColor',val2);
set(gca,'XTick',1:16)

figure(3);
% Range
% subplot(2,2,2);
title('Mission Range [nm]');
hold on;
grid on;
bar(Mission.Range,BarWidth,'FaceColor',val1,'EdgeColor',val2);
set(gca,'XTick',1:16)

figure(4);
% Fuel
% subplot(2,2,3);
title('Mission Fuel [kg]');
hold on;
grid on;
bar(Mission.Fuel,BarWidth,'FaceColor',val1,'EdgeColor',val2);
set(gca,'XTick',1:16)

figure(5);
% Mass
% subplot(2,2,4);
title('Aircraft Mass [kg]');
hold on;
grid on;
bar(Mission.Mass,BarWidth,'FaceColor',val1,'EdgeColor',val2);
set(gca,'XTick',1:16)

end
