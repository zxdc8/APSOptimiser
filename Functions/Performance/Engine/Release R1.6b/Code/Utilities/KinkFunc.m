function hkink_ft = KinkFunc( CAS_Above10k, Mach_Climb )
%KinkFunc calculates the kink altitude at which both the climb speed 
%and the climb Mach are at their limiting values.
% 
%hkink_ft = KinkFunc( Option, CAS_Above10k, Mach_Cruise, Mach_Diversion )
% 
%   Inputs:
%   Option         = 'Mission' / 'Diversion' 
%   CAS_Above10k   = Limit CAS               [kts]
%   Mach_Cruise    = Cruise Mach
%   Mach_Diversion = Diversion Mach
%
%   Outputs:
%   hkink_ft   = Kink altitude                    [ft]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    CAS_Above10k   = 300;
    Mach_Climb     = 0.80;
end

% Equation for fsolve MATLAB function
eqn=@(h_ft) (CAS2Mach(h_ft, CAS_Above10k) - Mach_Climb)*100;
% Initial estimate
h0 = 30000; % ft
% Options for fsolve MATLAB function
options = optimoptions('fsolve','Display','Off',...
    'TolX', 10e-4,'TolFun', 10e-7);
% Calculate the kink altitude
hkink_ft = fsolve(eqn,h0,options);       

end


