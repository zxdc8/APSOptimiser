function data = EngineGridFunc3( Setting, Extrap, EngFileName, M_ext )
%EngineGridFunc grids the engine data into a usable look-up grid
% 
% Created by: *D Rezgui*, *S Mitchell* and *M Gibbons*, 
% University of Bristol 2017

if nargin <4
    M_ext = [];  % Extend Mach numner range to M_ext
end
if nargin <1
    Setting = 'Cruise';
    Extrap  = 1;
    % EngFileName = 'UBB65Data';
    EngFileName = 'DP2001Data';
    % EngFileName = 'TF25Data';
end

T_inc = 20; % Number of Thrust data points
M_inc = 20; % Number of Mach number data points

%% Select an aircraft
RawEngineData = feval(EngFileName);

%% Select a thrust setting
switch (Setting)
    case 'Diversion'
        RawData = RawEngineData.Diversion;
    case 'Climb'
        RawData = RawEngineData.Climb;
    case 'Descent'
        RawData = RawEngineData.Descent;
    case 'Cruise'
        RawData = RawEngineData.Cruise;
    case {'Hold', 'Approach'}
        RawData = RawEngineData.Hold;
end

%% Assign vectors
h_vec   = RawData(:,1); % Altitude
M_vec   = RawData(:,2); % Mach number
T_vec   = RawData(:,3); % Thrust
FF_vec  = RawData(:,4); % Fuel Flow

%% Identify the form of the raw engine data
% If t==0, then there is only a single thrust value at each altitude-Mach
% so we are unable to interpolate using the known thrust. We shall instead
% scale the fuel flow using the known thrust.
%
% If t~=0, there are multiple thrust values at each altitude-Mach so we are
% able to interpolate.
% t = sum(diff([0; find(diff(M_vec))]))
t = sum(diff([0; find(diff(M_vec)); length(M_vec)])-1);

% Select suitable gridding method
if t == 0
    %% Case for when a single thrust and fuel flow is given at each altitude and Mach
    % Break Mach range into increments
    M  = linspace(min(M_vec),max(M_vec),M_inc);
    % Find the points at which altitude changes
    hd = [0; find(diff(h_vec)); length(h_vec)];
    % For each altitude
    for i = 1:length(hd)-1
        % Find first point
        h_l(i) = hd(i)+1;
        % Find final point
        h_u(i)  = hd(i+1);
        % Interpolate to find thrust and fuel flow at altitude-Mach
        if Extrap == 1    % Extrapolation ON
            Tdata(i,:)  = interp1(M_vec(h_l(i):h_u(i)),T_vec(h_l(i):h_u(i)),M,'linear','extrap');
            FFdata(i,:) = interp1(M_vec(h_l(i):h_u(i)),FF_vec(h_l(i):h_u(i)),M,'linear','extrap');
        else              % Extrapolation OFF
            Tdata(i,:)  = interp1(M_vec(h_l(i):h_u(i)),T_vec(h_l(i):h_u(i)),M,'linear');
            FFdata(i,:) = interp1(M_vec(h_l(i):h_u(i)),FF_vec(h_l(i):h_u(i)),M,'linear');
        end
    end
    % List all altitudes
    h = h_vec(h_l);
    % Create Mach-altitude grid
    [Mdata,hdata] = meshgrid(M, h);
    % Set thrust axis to zero
    T = 0;
    
elseif t~=0
    %% Case for when multiple thrust and fuel flow values given at each altitude and Mach
    % Break thrust range into increments
    T = linspace(min(T_vec),max(T_vec),T_inc); %% THIS CAN BE DEFINED SO IT VARIES WITH EACH DATA SUBSET
    % Find the points at which altitude changes
    hd = [0; find(diff(h_vec)); length(h_vec)];
    M_range = M_ext ; % Reset M_range to []
    % For each altitude
    for i = 1:length(hd)-1
        % Find first point
        h_l(i) = hd(i)+1;
        % Find final point
        h_u(i)  = hd(i+1);
        % Display h_l & h_u
        %disp(['Altitude ' num2str(i), ':  ', num2str(h_l(i)), '  ',    num2str(h_u(i)), '  ']);    M_set = M_vec(h_l(i):h_u(i));
        % Find set of Mach values
        M_set(i).v = M_vec(h_l(i):h_u(i));
        % Find the points at which Mach changes
        Md(i).v = [0; find(diff(M_set(i).v )); length(M_set(i).v)];
        
        % For each Mach at this altitude:
        for j = 1:length(Md(i).v)-1
            % Find first point
            M_l(i).v(j) = h_l(i) - 1 + Md(i).v(j) + 1;
            % Find final point
            M_u(i).v(j) = h_l(i) - 1 + Md(i).v(j+1);
            % Display M_l & M_u
            %disp(['...... Mach ' num2str(j), ':  ', num2str(M_l(j)), '  ',    num2str(M_u(j)), '  ']);
            M(i).v(j) = M_vec(M_l(i).v(j));
            % Break thrust range into increments
            TT(i).M(j).v = linspace(min(T_vec(M_l(i).v(j):M_u(i).v(j))),max(T_vec(M_l(i).v(j):M_u(i).v(j))),T_inc); %% THIS CAN BE DEFINED SO IT VARIES WITH EACH DATA SUBSET
            
            % Interpolate the fuel flow data
            if Extrap == 1      % Extrapolation ON
                FF(i).v(j,:) = interp1(T_vec(M_l(i).v(j):M_u(i).v(j)), FF_vec(M_l(i).v(j):M_u(i).v(j)), T, 'linear', 'extrap');
            else                % Extrapolation OFF
                FF(i).v(j,:) = interp1(T_vec(M_l(i).v(j):M_u(i).v(j)), FF_vec(M_l(i).v(j):M_u(i).v(j)), T, 'linear');
            end
            %             FF(i).org(j,:) =  FF_vec(M_l(i).v(j):M_u(i).v(j));
        end
        % Find M_range
        b =   M(i).v;
        lia = ismember(b,M_range);
        M_range = [M_range, b(~lia)];
        lia2 = (M_range ~= 0);
        M_range = sort(M_range(lia2));
        
    end
    
    for i = 1:length(hd)-1
        if length(M(i).v)>1
            for n = 1:T_inc
                FF(i).int(:,n) = interp1(M(i).v, FF(i).v(:,n), M_range', 'linear', 'extrap');
            end
        elseif length(M(i).v) == 1
            FF(i).int(:,:) = repmat(FF(i).v(1,:), length(M_range),1);
            if length(M_range)> 1
                disp(['Engine data was constructed to cover Mach number range of ' num2str(M_range)])
                disp(['Altitude: ' num2str(h_vec(h_l(i)))])
            end
        end
        FFdata(i,:,:) = FF(i).int(:,:);
        % list all altitudes & Mach
        h = h_vec(h_l);
        %     M = M_vec(M_l);
        % Create Mach-altitude-thrust grid
        [Mdata, hdata, Tdata] = meshgrid(M_range, h, T);
        
    end
    % Save to output structure
    data.M_range= M_range;
    data.FF     = FF;
    data.TT     = TT;
    
end

%% Save to output structure
data.h      = h;
data.T      = T';
data.M      = M;
data.hdata  = hdata;
data.Mdata  = Mdata;
data.Tdata  = Tdata;
data.FFdata = FFdata;
data.Setting = Setting;
end