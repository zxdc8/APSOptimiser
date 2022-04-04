function CD = CDFunc(Phase, CL, Mach, Par)
%CDFunc calculates the drag coefficient
%
% CD = CDFunc( CD0, K, CL )
%
%   Inputs:
%   CD0 = Parasitic drag component      [-]
%   K   = Lift dependent drag component [-]
%   CL  = Lift coefficient              [-]
%
%   Outputs:
%   CD  = Drag coefficient              [-]
%
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    Phase =  'Clean';%'Clean';
    Mach = 0.9;
    CL = 0.55;
    Par = AC_B777_AJenk; % or ParFunc = 'AC_150C_twin';
    Par.DragRise = 1;
%     Par.DragRise_Func = 'DragRise_B777_AJenk';
end

DragRise_Func = Par.DragRise_Func;
switch Phase
    case 'Clean'
        CD0 = Par.CD0_Clean;
        K = Par.K_Clean;
        if Par.DragRise == 1
            dCdW = feval(DragRise_Func,CL, Mach);
        else
            dCdW = 0;
        end
    case 'LD'
        CD0 = Par.CD0_LD;
        K = Par.K_LD;
        dCdW = 0;
end

CD = CD0 + K .* CL.^2 + dCdW;

end
