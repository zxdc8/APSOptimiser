function massfilename = MassDist(iter);

%Units of measurement
Lunit = 1; % metres
Munit = 1; % kilograms
Tunit = 1; % seconds
Mass = 131375*0.453592;
filename = sprintf('case_%.0f.avl',iter);

[CoM_X_Disp, CoM_Y_Disp, CoM_Z_Disp, Seg_Mass] = MassPoints(Mass, filename);

massfilename=sprintf('mass_%.0f.mass',iter); 
gfile=fopen(massfilename,'w');
fprintf(gfile,'Lunit = %.2f m\n',Lunit);
fprintf(gfile,'Munit = %.2f kg\n',Munit);
fprintf(gfile,'Tunit = %.2f s\n\n',Tunit);

fprintf(gfile,'g = 9.81\n');
fprintf(gfile,'rho = 1.225\n\n');

for mc = [1:length(Seg_Mass)]
fprintf(gfile,'%.2f %.2f %.2f %.2f 0 0 0\n',Seg_Mass(mc),CoM_X_Disp(mc),CoM_Y_Disp(mc),CoM_Z_Disp(mc));
fprintf(gfile,'%.2f %.2f -%.2f %.2f 0 0 0\n',Seg_Mass(mc),CoM_X_Disp(mc),CoM_Y_Disp(mc),CoM_Z_Disp(mc));
end

fclose(gfile);

copyfile( 'mass_1.mass', 'mass_1.txt' );

end