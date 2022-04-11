function AF = AccelFactorFunc( h_ft, M, Mmax)
%AccelFunc calculates the Climb or Descent Acceleration Factor
% 
%AF = AccelFactorFunc( h_ft, M, Mmax)
%
%   Inputs:
%   h_ft = Altitude                         [ft]
%   M    = Mach number [-] / CAS            [kts]
%   Mmax = Maximum Mach in climb or descent [Mach]

%   Outputs:
%   AF   = Acceleration Factor = (V/g)*(dV/dh) [-]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    h_ft = linspace(0,39000,300);
    M = linspace(0.1,0.8,300);
    Mmax = 0.8;
end

%% Boeing Company - Jet Transport Performance Methods
%% Acceleration Correction Factors page 3.141
% (V/g)*(dV/dh) = 0.5 * gamma * M^2 * psi
% For constant Mach: psi = 0   - K*Tstd/T
% For constant CAS:  psi = phi - K*Tstd/T

% Where K=lambda*R=0 above tropopause (h>36000ft)
% Where K=lambda*R=0.190263 below tropopause (h<36000ft)

h = ft2m(h_ft);
gamma = 1.4;
phi   = (M < Mmax) .* ((1 + 0.2 .* M.^2).^3.5 - 1) ./ (0.7 .* M.^2 .* (1 + 0.2 .* M.^2).^2.5);
K     = 0.190263 * (h < 11000);
psi   = phi - K;
AF    = 0.5 .* gamma .* M.^2 .* psi;
% plot(h_ft, AF)
end


