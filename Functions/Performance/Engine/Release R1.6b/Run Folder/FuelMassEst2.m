clear all
close all

%% Run Design Set
%This file is based on AVDASI 4 RunDesignSet - with output of Wf - fuel
%weight, and Vf - Volume of fuel tanks
%It accepts the following Opt variables Mach number, M, Cruise Altitude,
%Alt, Wing Surface Area, S, Zero Lift Drag Coef, CD0, Induced Drag factor,
%k

%% Initialise aircraft parameters


disp(' ')
disp('        ******** Aircraft Performance Tool ********');
disp('        ******** Run Design Mission Case ********')
disp(' ')

% Read Aircraft data from a re-defined file, e.g. BWB for the blended wing
% body design
ParFunc = 'BWB';
Par     = eval(ParFunc);  % Set parameters in the "Par" object, 
                          % Default values are set in the ParFunc

disp(['... Aircraft parameters are set, based on ', ParFunc, ' data file'])
disp(' ')


%% Calculate the mass, fuel and range for a set of missions


Par.Mach_Cruise            = 0.7;      % Mach number cruise [-]
Par.Alt_Cruise             = 38000;     % Cruise Alt [ft]
Par.S                      = 3300;       % Wing area [m^2] (DP)
Par.CD0_Clean              = 0.0059;     % Zero Lift Drag Coef [-] (DP)
Par.K_Clean                = 0.048;     % Induced Drag factor - clean [-] (DP)




% Extra parameters that are set but might be modified - Look at Weight
Par.Range_req              = 7750;      % Required design range [nm] (DP)
Par.PLmax                  = 105160;     % Max payload [kg] (DP)
Par.MFC                    = 60000;     % Max Fuel capacity [kg] (DP)
Par.MTOM                   = 313000;    % Max Take Off Mass [kg] (DP)
Par.Airframe               = 131375;    % Operating Mass Empty [kg] (DP)
Par.PL_req                 = 105160;     % Design Payload [kg] (DP)

Par.SF = 6;


% call function FindDesignPoint to calculate mission properties
dp1 = FindDesignPoint(Par);


for jj = 1:16
 while dp1.Mission.Range(jj)< 0
     
    Par.SF = Par.SF + 1; 
     
     dp1 = FindDesignPoint(Par);

 end
 
end

% 
%  while dp1.Mission.Data.ROC_fpm(end)< 0
%      
%     Par.SF = Par.SF + 1; 
%      
%      dp1 = FindDesignPoint(Par);
% 
%  end
 

 

%% Output results

     astring = ['SF = ' num2str(Par.SF)];
     disp(astring)
     
     
     
Meng = enginemass(Par.SF);

%Fuel Consumption
Mf = dp1.TotalFuel;

%Fuel Volume required
rholh2 = 71; %[kg/m3]


Vf = (Mf)/rholh2;%[m3]


% end
