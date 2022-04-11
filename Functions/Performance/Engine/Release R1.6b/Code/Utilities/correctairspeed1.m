function out = correctairspeed1( in, a, P0, ain, aout )
%  CORRECTAIRSPEED Calculate equivalent airspeed (EAS), calibrated airspeed
%  (CAS) or true airspeed (TAS) from one of the other two airspeeds.
%   AS = CORRECTAIRSPEED( V, A, P0, AI, AO ) computes the conversion factor
%   from specified input airspeed, AI, to specified output airspeed, AO,
%   using speed of sound, A, and static pressure P0.  The conversion factor
%   is applied to the input airspeed, V, to produce the output, AS, in the
%   desired airspeed.  V, AS, A and P0 are floating point arrays of size M.
%   All of the values in V must have the same airspeed conversions from AI
%   to AO.  AI and AO are strings. 
%
%   Input required by CORRECTAIRSPEED is:
%   V      :airspeed in meters per second. 
%   A      :speed of sound in meters per second.
%   P0     :static air pressure in pascal.
%   AI     :input airspeed string
%   AO     :output airspeed string
%
%   Supported airspeed strings are:
%      'TAS'   :true airspeed    
%      'CAS'   :calibrated airspeed
%      'EAS'   :equivalent airspeed
%
%   Output calculated is: 
%   AS     :airspeed in meters per second. 
%
%   Limitations: 
%
%   Based on assumption of compressible, isentropic (subsonic flow), dry
%   air with constant specific heat ratio (gamma).  
%
%   Example:
%
%   Convert three airspeeds from true airspeed to equivalent airspeed at 1000 meters: 
%      as = correctairspeed([25.7222; 10.2889; 3.0867], 336.4, 89874.6,'TAS','EAS')
%
%   Convert airspeeds from true airspeed to equivalent airspeed at 1000 and 0 meters: 
%      ain = [25.7222; 10.2889; 3.0867];
%      sos = [336.4; 340.3; 340.3];
%      P0 = [ 89874.6; 101325; 101325];
%      as = correctairspeed( ain, sos, P0,'TAS','EAS')
%
%   See also AIRSPEED.

%   Copyright 2000-2016 The MathWorks, Inc.

%   References:
%   [1] Lowry, J. T., Performance of Light Aircraft, AIAA Education Series,
%   Washington, DC, 1999.  
%   [2] Aeronautical Vestpocket Handbook, United Technologies Pratt &
%   Whitney, August, 1986. 

if ~isfloat( in )
    error(message('aero:correctairspeed:notFloat1'));
end

if ~isfloat( a )
    error(message('aero:correctairspeed:notFloat2'));
end

if ~isfloat( P0 )
    error(message('aero:correctairspeed:notFloat3'));
end

if ~ischar( ain ) && ~isstring( ain )
    error(message('aero:correctairspeed:notChar1'));
end

if ~ischar( aout ) && ~isstring( aout )
    error(message('aero:correctairspeed:notChar2'));
end

if (strcmpi(ain,'cas') || strcmpi(aout,'cas'))
    load('aeroascorrdata1.mat');
    [Vbp,Pbp]= meshgrid(aeroasV_bp, aeroasP_bp);
end

gamma = 1.4;
a0 = 340.2941;

try
    switch lower(ain)
        case 'tas'
            switch lower(aout)
                case 'tas'
                    out = in;
                case 'cas'
                    mach = in./a;
                    checkmach( mach );
                    eas = mach.*a0.*sqrt(rrdelta(P0, 0, gamma));
                    out = interp2( Vbp, Pbp, aeroasVc_table, eas, P0, 'spline');
                case 'eas'
                    mach = in./a;
                    checkmach( mach );
                    out = mach.*a0.*sqrt(rrdelta(P0, 0, gamma));
                otherwise
                    error(message('aero:correctairspeed:unknownAirspeed'));
            end
        case 'cas'
            switch lower(aout)
                case 'tas'
                    eas  = interp2(  Vbp, Pbp, aeroasVe_table, in, P0, 'spline');
                    mach = eas./(a0.*sqrt(rrdelta(P0, 0, gamma)));
                    checkmach( mach );
                    out = mach.*a;
                case 'cas'
                    out = in;
                case 'eas'
                    out = interp2(  Vbp, Pbp, aeroasVe_table, in, P0, 'spline');
                    checkmach( out./(a0.*sqrt(rrdelta(P0, 0, gamma))) );
                otherwise
                    error(message('aero:correctairspeed:unknownAirspeed'));
            end
        case 'eas'
            switch lower(aout)
                case 'tas'
                    mach = in./(a0.*sqrt(rrdelta(P0, 0, gamma)));
                    checkmach( mach );
                    out = mach.*a;
                case 'cas'
                    checkmach( in./(a0.*sqrt(rrdelta(P0, 0, gamma))) );
                    out = interp2(  Vbp, Pbp, aeroasVc_table, in, P0, 'spline');
                case 'eas'
                    out = in;
                otherwise
                    error(message('aero:correctairspeed:unknownAirspeed'));
            end
        otherwise
            error(message('aero:correctairspeed:unknownAirspeed'));
    end
catch UnkAirspeed
    switch UnkAirspeed.identifier
        case 'aero:correctairspeed:unknownAirspeed'
            rethrow(UnkAirspeed)
        case 'aero:checkmach:supersonic'
            rethrow(UnkAirspeed)
        otherwise
               error(message('aero:correctairspeed:wrongDimension'));
    end
end

%=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
function checkmach(mach)
    if any(mach >= 1.0)
        error(message('aero:checkmach:supersonic'));
    end
