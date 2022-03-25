%///////CALLS AVL/////////
function outname = AVLcall(avl,mass,run,i)
%define command file
cmdfile=fopen('.\.\commandfile.txt','w');

%load input files, disable graphics, enter run window
fprintf(cmdfile,'LOAD Inputs/AVLcases/%s\nMASS Inputs/%s\nCASE Inputs/%s\nPLOP\nGF\n\nmset\n0\nOPER\n\n',avl,mass,run);

%Initialise, run, get forces
tot_forc=sprintf('Out_Force_%.0f.txt',i);
stab_deri=sprintf('Stab_Deri_%.0f.txt',i);
fprintf(cmdfile,'#\nX\nFT\n%s\nO\n',tot_forc);
fprintf(cmdfile,'#\nX\nST\n%s\nO\n\n',stab_deri);

%Plot Geometry
fprintf(cmdfile,'G\nV\n0 90\nH\n');

% %Exit
% fprintf(cmdfile,'\nquits');

fclose(cmdfile);

system('avl < commandfile.txt');

%Move output files
tot_forc=sprintf('Out_Force_%.0f.txt',i);
movefile(tot_forc,'Outputs/Forces');
stab_deri=sprintf('Stab_Deri_%.0f.txt',i);
movefile(stab_deri,'Outputs/Stability');

%Move plot file
filename=sprintf('geom_%.0f.ps',i)
movefile('plot.ps',filename)
movefile(filename,'Outputs/Plots/Geometry')

outname=sprintf('out_%.0f.txt',i);

end

