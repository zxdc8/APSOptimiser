function [ FF_engine, T_engine ] = EngineInterpFunc( data, h_ft, Mach, T_engine, ThrustFlag, Extrap, Par )
% [ FF_engine, T_engine ] = EngineInterpFunc( data, h_ft, Mach, T_engine, ThrustFlag, Extrap, Par )
%
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin < 1
    Par = AC_DP2001;
    
    %     Par = AC_150C_twin;
    EngineData = GriddedEngineData(Par);
    data       = EngineData.Approach;
    h_ft = 1500;
    Mach = 0.35;
    T_engine = -2692.101306;
    ThrustFlag = 'known'; % 'UnKnown'
    Extrap = 1;
end
filename = 'display.txt';
% fid = fopen(filename,'a');
interp_method = Par.interp_method; % 'spline' or 'linear'
display = Par.display;

% Use data.T to select which method to use
if data.T == 0
    %% Case for when a single thrust and fuel flow is given at each altitude and Mach
    % Assign data
    hdata  = data.hdata;
    Mdata  = data.Mdata;
    Tdata  = data.Tdata;
    FFdata = data.FFdata;
    % Interp2 to find T and FF
    T_tag  = interp2(Mdata, hdata, Tdata, Mach, h_ft, interp_method);
    FF_tag = interp2(Mdata, hdata, FFdata, Mach, h_ft, interp_method);
    % Switch method depending on whether the engine thrust is known or not
    switch (ThrustFlag)
        case 'Known'
            % This is a cruise condition where the engine thrust is known
            % Linearly scale the fuel flow using the known T_engine
            % Assume that linear scaling is appropriate and valid
            ScaleFactor = T_engine / T_tag;
            FF_engine   = FF_tag * ScaleFactor;
        case 'Unknown'
            % This is not a cruise condition so the engine thrust is
            % unknown and we are looking it up as well as fuel flow
            T_engine  = T_tag;
            FF_engine = FF_tag;
    end
elseif data.T ~= 0
    %% Case for when multiple thrust and fuel flow values given at each altitude and Mach
    % Squeeze gridded data
    hdata  = squeeze(data.hdata);
    Mdata  = squeeze(data.Mdata);
    Tdata  = squeeze(data.Tdata);
    FFdata = squeeze(data.FFdata);
    % Identify if altitude or Mach only have a single value
    s = size(data.FFdata)==1;
    % Select correct interpolation
    if s(1)==1 && s(2)==1
        %% Case 1: Single value for both altitude and Mach
        % Check that the target altitude if similar to the single altitude value
        dh = CheckAltFunc( hdata(1), h_ft , Par);
        % Check that the target Mach if similar the single Mach value
        dM = CheckMachFunc( Mdata(1), Mach, Par);
        % Interpolate fuel flow data
        if Extrap == 1  % EXTRAPOLATION ON
            FF_engine = interp1(Tdata, FFdata, T_engine, interp_method, 'extrap');
        else            % EXTRAPOLATION OFF
            FF_engine = interp1(Tdata, FFdata, T_engine, interp_method);
        end
    elseif s(1)==1 && s(2)==0
        %% Case 2: Single value for altitude
        % Check that the target altitude if similar the single altitude value
        dh = CheckAltFunc( hdata(1), h_ft, Par);
        % Interpolate fuel flow data
        FF_engine = interp2( Mdata, Tdata, FFdata, Mach, T_engine, interp_method);
        % Message
        if Extrap == 1 && display == 1
            fid = fopen(filename,'a');
            fprintf(fid,[data.Setting ' ... No extrapolation with interp2. \n']);
            fclose(fid);
            %             disp('Unable to extrapolate with interp2');
        end
    elseif s(1)==0 && s(2)==1
        %% Case 3: Single value for Mach number
        % Check that the target Mach is the single Mach value
        dM = CheckMachFunc( Mdata(1), Mach, Par);
        % Interpolate fuel flow data
        FF_engine = interp2( hdata, Tdata, FFdata, h_ft, T_engine, interp_method);
        % Message
        if Extrap == 1 && display == 1
            fid = fopen(filename,'a');
            fprintf(fid,[data.Setting ' ... No extrapolation with interp2. \n']);
            fclose(fid);
            %             disp('Unable to extrapolate with interp2');
        end
    elseif s(1)==0 && s(2)==0
        %% Case 4: Multiple values for altitude and Mach
        % Interpolate fuel flow data
        FF_engine = interp3(data.Mdata, data.hdata, data.Tdata, data.FFdata, Mach, h_ft, T_engine, interp_method);
        if isnan(FF_engine) == 1
            fid = fopen(filename,'a');
            fprintf(fid,['ERROR: Data required for ', data.Setting , ' is outside available range ... \n']);
            fprintf(fid,['Mach number: ',num2str(Mach),', Alt: ' ,num2str(h_ft),' ft, Thrust: ' ,num2str(T_engine), ' lb. \n' ]);
            fclose(fid);
            error(['Data required for ', data.Setting , ' is outside available range. ' ...
                'Mach number: ',num2str(Mach),', Alt: ' ,num2str(h_ft),' ft, Thrust: ' ,num2str(T_engine), ' lb.' ]);
        end
        % Message
        if Extrap==1 && display == 1
            fid = fopen(filename,'a');
            fprintf(fid,[data.Setting ' ... No extrapolation with interp3. \n']);
            fclose(fid);
            %             disp('Unable to extrapolate with interp3');
        end
    end
    
    % fclose(fid);
end