function FF = EngineApproachFunc( T )
%EngineApproachFunc outputs the fuel flow for a given thrust at Mach 0.35 at 1500ft
%   Inputs:
%   T   = Thrust per engine    [N]
%   Outputs:
%   FF  = Fuel Flow per engine [kg/hr]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    T = 50000;
end

%% Approach Data is the scaled UBB65 cruise data for 1500ft Mach 0.35
Data = [-521.3656172	461.341957	;
        67244.39056     2583.68293	;
        84054.90456     3083.942096	;
        100867.1973     3594.347016	;
        134487.2247     4664.654638	;
        168108.4751     5752.255709	;
        180761.8848     6171.736005	];
%% Linear interpolation  
T_vec  = Data(:,1);
FF_vec = Data(:,2);
FF = interp1(T_vec, FF_vec, T, 'linear');


end

