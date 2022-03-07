function PlotPLRD(plrd, marker)
% PlotMission(Mission)
% Plot time, range,fuel mass and aircraft mass for a mission
%
% Copyright: University of Bristol

%% Test
if nargin < 2
    marker = 'b';
end

%% Plot the data points for the MTOM and MFC cases - DO NOT CHANGE
disp('Plot Payload/Range Diagram')

figure(100)
% Plot Maximum Payload curve
plot([0  plrd.Range_PLmax], [plrd.PLmax  plrd.PLmax ], marker); hold on
% Plot MTOM curve
plot(plrd.Range_MTOM , plrd.Payload_MTOM , marker)
% Plot MFC curve
plot(plrd.Range_MFC, plrd.Payload_MFC, marker)

% Circle the junction point where the Maximum Payload and MTOM curves meet
plot(plrd.Range_PLmax, plrd.PLmax, 'or')
% Circle the junction point where the MTOM and MFC curves meet
plot(plrd.Range_p , plrd.Payload_p, 'or')
% Circle the maximum range (ferry range) point 
plot(plrd.Range_max, 0, 'or')
% Circle the maximum range (ferry range) point 
plot(plrd.Range_max, 0, 'or')
% Circle the required design point 
plot(plrd.dp.Range_req, plrd.dp.PL_req, '*m','MarkerSize',10)

% Add title and axis labels to the payload-range diagram
title('Payload-Range Diagram')
xlabel('Range (nm)')
ylabel('Payload (kg)')
% Add axis limitations
x_max = 1000 * ceil(plrd.Range_max / 1000);
y_max = 10000 * ceil(plrd.PLmax / 10000);
axis([0 x_max 0 y_max])
% Add grid
grid on; hold on

disp('... Done ....')
disp(' ')
