function [massfilename, Area_Pass, Vol_Fuel, Fuel_Mass] = MassDist(Np, iter, Struc_Mass, Payload_Mass)

%Units of measurement
Lunit = 1; % metres
Munit = 1; % kilograms
Tunit = 1; % seconds

filename = sprintf('././Inputs/AVLcases/case_%.0f.avl',iter);
% filename = sprintf('C:/Users/Joe/OneDrive - University of Bristol/Documents/GitHub/APSOptimiser/Inputs/AVLcases/case_%.0f.avl',iter); %/\/\/\/\

%Establish .mass file and dimensional units of measurements into file
massfilename=sprintf('././Inputs/Massfiles/mass_%.0f.mass',iter) 
% massfilename=sprintf('C:/Users/Joe/OneDrive - University of Bristol/Documents/GitHub/APSOptimiser/Inputs/Massfiles/mass_%.0f.mass',iter); %/\/\/\/\

gfile=fopen(massfilename,'w');
fprintf(gfile,'Lunit = %.2f m\n',Lunit);
fprintf(gfile,'Munit = %.2f kg\n',Munit);
fprintf(gfile,'Tunit = %.2f s\n\n',Tunit);

%Establish flight environment factors
fprintf(gfile,'g = 9.81\n');
fprintf(gfile,'rho = 1.225\n\n');

%% Loops implement point masses of BWB components
%--------Below loop implements Mass points of BWB's wing strucutre based on
%volume and equal mass density distribution of strucutres material---------
Struc_Mass = Struc_Mass*0.453592;
[CoM_X_Disp, CoM_Y_Disp, CoM_Z_Disp, Seg_Mass, Vol_Seg, Wing_Pos] = MassPoints(Struc_Mass, filename); %Function Calls CoM points of Wing Strucutre based on .avl file

for mc = [1:length(Seg_Mass)]
fprintf(gfile,'%.2f %.2f %.2f %.2f 0 0 0\n',Seg_Mass(mc),CoM_X_Disp(mc),CoM_Y_Disp(mc),CoM_Z_Disp(mc));
fprintf(gfile,'%.2f %.2f -%.2f %.2f 0 0 0\n',Seg_Mass(mc),CoM_X_Disp(mc),CoM_Y_Disp(mc),CoM_Z_Disp(mc));
end
fprintf(gfile,'\n');

% Below loop implements Mass point of Passengers based on area of 1st and 2nd segment
Payload_Mass = Payload_Mass*0.453592;
Fuel_Mass = Vol_Seg(2)*71; %Fuel segment Volume * Hydrogen Fuel density
[CoM_Array] = MassPayPoints(Np, Vol_Seg, Payload_Mass, Fuel_Mass, filename);

for mcc = [1:length(CoM_Array)]
    CoM = CoM_Array{mcc};
    for mc = [1:length(CoM(1,:))]
        fprintf(gfile,'%.2f %.2f %.2f %.2f 0 0 0\n',CoM(4,mc),CoM(1,mc),CoM(2,mc),CoM(3,mc));
        fprintf(gfile,'%.2f %.2f -%.2f %.2f 0 0 0\n',CoM(4,mc),CoM(1,mc),CoM(2,mc),CoM(3,mc));
    end
    fprintf(gfile,'\n');
end

Area_Pass = sum(CoM_Array{1}(4,:));
Vol_Fuel = sum(CoM_Array{2}(4,:));

%% Graph Mass point coords of BWB components
BWB_Mass_Graph(Np, Wing_Pos, CoM_Array{1}, CoM_Array{2}, CoM_X_Disp, CoM_Y_Disp)

fclose(gfile);

%copyfile( 'mass_1.mass', 'mass_1.txt' );

end