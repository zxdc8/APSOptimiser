function CAS_kts = Mach2CAS( h_ft, M )
%Mach2CAS coverts a Mach number to CAS for a given altitude
%   Inputs:
%   h_ft = Altitude [ft]
%   M = Mach [-]
%   Outputs:
%   CAS_kts = Calibrated Air Speed [kts]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    M = ones(1,100)*0.8; % kts
    h_ft = linspace(0,35000,100); % ft
end

h = ft2m(h_ft);

[Temp0, a0, ~, ~] = atmosisa(0); %atmosisa is a MATLAB function
[Temp, a, P, ~] = atmosisa(h); %atmosisa is a MATLAB function

TAS = a0 .* M .* (Temp./Temp0).^(0.5);

% CAS = correctairspeed(TAS, a, P, 'TAS', 'CAS','Equation');%correctairspeed is a MATLAB function
% CAS = correctairspeed(TAS, a, P, 'TAS', 'CAS','TableLookup'); % Convert to TAS
CAS = correctairspeed(TAS, a, P, 'TAS', 'CAS','Equation'); % Convert to TAS
% CAS = correctairspeed1(TAS, a, P, 'TAS', 'CAS'); % Convert to TAS

CAS_kts = mps2kts(CAS);

end
