function [ ROC ] = ROCFunc( T, D, V, W, AF )
% [ ROC ] = ROCFunc( T, D, V, W, AF )
% ROCFunc calculates the rate of climb
%   Inputs:
%   T = Thrust [N]
%   D = Drag [N]
%   V = Velocity [m/s]
%   W = Weight [N]
%   AF = Acceleration Factor = (V/g)*(dV/dh) [dimensionless]
%   Outputs:
%   ROC = Rate of climb [m/s]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

ROC = ((T-D)*V) / (W*(1+AF));

end

