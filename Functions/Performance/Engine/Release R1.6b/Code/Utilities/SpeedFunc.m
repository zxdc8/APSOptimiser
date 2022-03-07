function [ CAS ] = SpeedFunc( M, h )
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

% Speed of sound and pressure at sea level
[~,a0,p0] = atmosisa(0);
% Pressure at altitude
[~,~,p] = atmosisa(h);

% Impact pressure
qc = p * ( (1 + 0.2 * M.^2)^(2/7) - 1);

% CAS
CAS = a0 * sqrt (5 * ( ((qc/p0)+1)^(2/7) - 1));



end

