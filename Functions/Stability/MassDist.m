function massfilename = MassDist(iter, Struc_Mass, Payload_Mass, Fuel_Mass)


%Units of measurement
Lunit = 1; % metres
Munit = 1; % kilograms
Tunit = 1; % seconds

filename = sprintf('case_%.0f.avl',iter);

%Establish .mass file and dimensional units of measurements into file
=======
Mass = 131375*0.453592;
filename = sprintf('case_%.0f.avl',iter);

[CoM_X_Disp, CoM_Y_Disp, CoM_Z_Disp, Seg_Mass] = MassPoints(Mass, filename);

>>>>>>> abf7b881a385c434dba1d9ee54ad87c6fc9aad7b
massfilename=sprintf('mass_%.0f.mass',iter); 
gfile=fopen(massfilename,'w');
fprintf(gfile,'Lunit = %.2f m\n',Lunit);
fprintf(gfile,'Munit = %.2f kg\n',Munit);
fprintf(gfile,'Tunit = %.2f s\n\n',Tunit);

<<<<<<< HEAD
%Establish flight environment factors
fprintf(gfile,'g = 9.81\n');
fprintf(gfile,'rho = 1.225\n\n');

%% Loops implement point masses of BWB components
%--------Below loop implements Mass points of BWB's wing strucutre based on
%volume and equal mass density distribution of strucutres material---------
Struc_Mass = Struc_Mass*0.453592;
[CoM_X_Disp, CoM_Y_Disp, CoM_Z_Disp, Seg_Mass, Vol_Seg, Wing_Pos] = MassPoints(Struc_Mass, filename); %Function Calls CoM points of Wing Strucutre based on .avl file

=======
fprintf(gfile,'g = 9.81\n');
fprintf(gfile,'rho = 1.225\n\n');

>>>>>>> abf7b881a385c434dba1d9ee54ad87c6fc9aad7b
for mc = [1:length(Seg_Mass)]
fprintf(gfile,'%.2f %.2f %.2f %.2f 0 0 0\n',Seg_Mass(mc),CoM_X_Disp(mc),CoM_Y_Disp(mc),CoM_Z_Disp(mc));
fprintf(gfile,'%.2f %.2f -%.2f %.2f 0 0 0\n',Seg_Mass(mc),CoM_X_Disp(mc),CoM_Y_Disp(mc),CoM_Z_Disp(mc));
end
<<<<<<< HEAD
fprintf(gfile,'\n');

% Below loop implements Mass point of Passengers based on area of 1st and 2nd segment
Payload_Mass = Payload_Mass*0.453592;
Fuel_Mass = Fuel_Mass*0.453592;
[CoM_Pass, CoM_Fuel] = MassPayPoints(Vol_Seg, Payload_Mass, Fuel_Mass, filename);

for mcc = [1:2]
    for mc = [1:length(CoM_Fuel(1,:))]
        fprintf(gfile,'%.2f %.2f %.2f %.2f 0 0 0\n',CoM_Fuel(4,mc),CoM_Fuel(1,mc),CoM_Fuel(2,mc),CoM_Fuel(3,mc));
        fprintf(gfile,'%.2f %.2f -%.2f %.2f 0 0 0\n',CoM_Fuel(4,mc),CoM_Fuel(1,mc),CoM_Fuel(2,mc),CoM_Fuel(3,mc));
    end
    fprintf(gfile,'\n');
end


%% Graph Mass point coords of BWB components
BWB_Mass_Graph(Wing_Pos, CoM_Pass, CoM_Fuel, CoM_X_Disp, CoM_Y_Disp)
=======
>>>>>>> abf7b881a385c434dba1d9ee54ad87c6fc9aad7b

fclose(gfile);

copyfile( 'mass_1.mass', 'mass_1.txt' );

end