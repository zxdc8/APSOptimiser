function y = TimeFunc( x, ti, to )
%TimeFunc converts between seconds, minutes and hours
%
% y = TimeFunc( x, ti, to )
%
%   Inputs:
%   x  = InputTime
%   ti = Input units ('sec' / 'min' / 'hr')
%   to = Output units ('sec' / 'min' / 'hr')
%
%   Outputs:
%   y  = Time [hr]
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol

switch (ti)
    case 'sec'
        switch (to)
            case 'sec'
                y = x;
                warning('No need for conversion.');
            case 'min'
                y = x ./ 60;
            case 'hr'
                y = x ./ 3600;
        end
       
    case 'min'
        switch (to)
            case 'sec'
                y = x .* 60;
            case 'min'
                y = x;
                warning('No need for conversion.');
            case 'hr'
                y = x ./ 60;
        end
        
    case 'hr'
        switch (to)
            case 'sec'
                y = x .* 3600;
            case 'min'
                y = x .* 60;
            case 'hr'
                y = x;
                warning('No need for conversion.');
        end
end
         
end

