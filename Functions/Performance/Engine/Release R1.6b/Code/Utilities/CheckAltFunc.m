function dh = CheckAltFunc( Available, Target, Par)
%CheckAltFunc compares the available altitude and target altitude
%
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    Available = 25000;
    Target    = 25700;
    Par = AC_DP2001;
end
filename = 'display.txt';
display = Par.display;
% Calculate difference between target and given altitudes
dh = abs(Available - Target);
% Max acceptable difference
dh_max = Par.dh_max; %5000;
% Check the magnitude of the difference
if dh == 0  && display == 1
    fid = fopen(filename,'a');
    fprintf(fid,['The target altitude (', num2str(Target), ' ft) is exactly the same as the available altitude.\n']);
    %         disp(['The target altitude (', num2str(Target), ' ft) is exactly the same as the available altitude.']);
    fclose(fid);
elseif dh <= dh_max  && display == 1
    fid = fopen(filename,'a');
    fprintf(fid,['Warning: There is a difference of ', num2str(dh), ' ft between the target altitude (', num2str(Target),...
        ' ft) and the available altitude (', num2str(Available), ' ft).\n']);
    fprintf(fid,['... This difference is within the acceptable limit of ', num2str(dh_max), ' ft.\n']);
    %     warning(['There is a difference of ', num2str(dh), ' ft between the target altitude (', num2str(Target), ' ft) and the available altitude (', num2str(Available), ' ft). This difference is within the acceptable limit of ', num2str(dh_max), ' ft.']);
    fclose(fid);
elseif dh > dh_max;
    error(['There is a difference of ', num2str(dh), ' ft between the target altitude (', num2str(Target), ' ft) and the available altitude (', num2str(Available), ' ft). This difference exceeds the acceptable limit of ', num2str(dh_max), ' ft.']);
end
end
