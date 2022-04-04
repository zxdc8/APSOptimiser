function PlotDSet(dp,par_set,xlab)
% PlotDSet(dp,par_set,xlab)
% PlotDSet plots the block time, block fuel and range for a set of missions
% 
% Created by D Rezgui 2017
% Copyright: University of Bristol

if nargin < 3
	xlab = 'x label []';
end

for i=1:length(par_set)
    BlockFuel(i)    = dp(i).TotalFuel;
    BlockTime(i)    = dp(i).Block.Time;
    MisRange(i,:)   = dp(i).Mission.Time;
end

% par_set = par_set/1000;

figure(10)
subplot(1,3,1)
grid on; hold all

plot(par_set,BlockFuel)

xlabel(xlab); ylabel('Total Fuel [kg]')





subplot(1,3,2)
grid on; hold all
plot(par_set,BlockTime)

xlabel(xlab); ylabel('Block Time [min]')


subplot(1,3,3)
plot(par_set,MisRange(:,4:6))
xlabel(xlab); ylabel('Mission Range [nm]')
grid on; hold all
legend('Climb','Cruise','Descent')

pos = get(gcf,'Position').*[1 1 1.5 1];
set(gcf,'Position',pos,'Name', 'Design Set Performance')
end