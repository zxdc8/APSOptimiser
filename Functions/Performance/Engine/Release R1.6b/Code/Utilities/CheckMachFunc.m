function dM = CheckMachFunc( Available, Target, Par )
%CheckMachFunc compares the available Mach and target Mach
%
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    Available = 0.82;
    Target    = 0.71;
    Par = AC_DP2001;
end
display = Par.display;
filename = 'display.txt';
% fid = fopen(filename,'a');
% Calculate difference between target and given Mach
dM = abs(Available - Target);
% Limit
dM_max = Par.dM_max; %0.20;
% Check the magnitude of the difference
if dM == 0 && display == 1
    fid = fopen(filename,'a');
    fprintf(fid,['The target Mach (', num2str(Target), ') is exactly the same as the available Mach. \n']);
    fclose(fid);
    %     disp(['The target Mach (', num2str(Target), ') is exactly the same as the available Mach.']);
    
elseif dM <= dM_max && display == 1
    
    fid = fopen(filename,'a');
    fprintf(fid, ['Warning: There is a difference of ', num2str(dM), ' between the target Mach (', ...
        num2str(Target), ') and the available Mach (', num2str(Available), ').\n']);
    fprintf(fid, ['... This difference is within the acceptable limit of ', num2str(dM_max), '.\n']);
    fclose(fid);
    %     warning(['There is a difference of ', num2str(dM), ' between the target Mach (', num2str(Target), ') and the available Mach (', num2str(Available), '). This difference is within the acceptable limit of ', num2str(dM_max), '.']);
elseif dM > dM_max;
    error(['There is a difference of ', num2str(dM), ' between the target Mach (', num2str(Target), ') and the available Mach (', num2str(Available), '). This difference exceeds the acceptable limit of ', num2str(dM_max), '.']);
end
% fclose(fid);
end
