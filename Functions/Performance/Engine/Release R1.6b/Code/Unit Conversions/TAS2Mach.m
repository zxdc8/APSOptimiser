function Mach = TAS2Mach( h_ft, TAS_mps )
%TAS2Mach converts a CAS to Mach number for a given altitude
%
% Mach = TAS2Mach( h_ft, TAS_mps )
%
%   Inputs:
%   h_ft    = Altitude [ft]
%   TAS_mps = True Air Speed [mps]
% 
%   Outputs:
%   M = Mach [-]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    TAS_kts = ones(1,100)*300; % kts
    h_ft = linspace(0,35000,100); % ft
end

h = ft2m(h_ft);

[Temp0, a0, P0, rho0] = atmosisa(0); %atmosisa is a MATLAB function
[Temp, a, P, rho] = atmosisa(h); %atmosisa is a MATLAB function

Mach = TAS_mps .* (Temp ./ Temp0).^(-0.5) ./ a0;

end
