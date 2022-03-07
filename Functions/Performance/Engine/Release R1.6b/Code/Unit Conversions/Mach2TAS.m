function TAS_mps = Mach2TAS( h_ft, M )
%Mach2CAS coverts a Mach number to TAS for a given altitude
%   Inputs:
%   h_ft = Altitude [ft]
%   M    = Mach     [-]
%   Outputs:
%   TAS_mps = True Air Speed [m/s]
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

end
