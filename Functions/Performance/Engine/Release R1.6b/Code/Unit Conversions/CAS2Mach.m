function M = CAS2Mach( h_ft, CAS_kts )
%CAS2Mach converts a CAS to Mach number for a given altitude
%   h_ft = Altitude [ft]
%   CAS_kts = Calibrated Air Speed [kts]
%   Outputs:
%   M = Mach [-]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    CAS_kts = ones(1,100)*300; % kts
    h_ft = linspace(0,35000,100); % ft
end

h = ft2m(h_ft);
CAS = kts2mps(CAS_kts);

[Temp0, a0, P0, rho0] = atmosisa(0); %atmosisa is a MATLAB function
[Temp, a, P, rho] = atmosisa(h); %atmosisa is a MATLAB function

% TAS = correctairspeed(CAS, a, P, 'CAS', 'TAS','Equation'); %correctairspeed is a MATLAB function
% TAS = correctairspeed(CAS, a, P, 'CAS', 'TAS','TableLookup'); % Convert to TAS
TAS = correctairspeed(CAS, a, P, 'CAS', 'TAS','Equation'); % Convert to TAS
% TAS = correctairspeed1(CAS, a, P, 'CAS', 'TAS'); % Convert to TAS

M = TAS.*(Temp./Temp0).^(-0.5)./a0;

end
