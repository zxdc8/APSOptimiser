%///////CALLS AVL/////////
function outname = AVLcall(avl,mass,run,i)


%Debug, print iteration
sprintf('%i',i)

filename=sprintf('././CommandFiles/commandfile_%i.txt',i)

%define command file
cmdfile=fopen(filename,'w');

%load input files, disable graphics, enter run window
fprintf(cmdfile,'LOAD Inputs/AVLcases/%s\nMASS Inputs/Massfiles/%s\nCASE Inputs/%s\nPLOP\nGF\n\nmset\n0\nOPER\n',avl,mass,run);
% fprintf(cmdfile,'LOAD %s\nMASS %s\nCASE %s\nPLOP\nGF\n\nmset\n0\nOPER\n',avl,mass,run); %/\/\/\


%Initialise, run, get forces
tot_forc=sprintf('Out_Force_%.0f.txt',i);
stab_deri=sprintf('Stab_Deri_%.0f.txt',i);
fprintf(cmdfile,'X\nFT\n%s\n',tot_forc);
fprintf(cmdfile,'ST\n%s\n',stab_deri);

%Plot Geometry
%fprintf(cmdfile,'G\nV\n0 90\nH\n');

% %Exit
% fprintf(cmdfile,'\nquits');

fclose(cmdfile);

avlcmd=sprintf('avl < CommandFiles/commandfile_%i.txt',i)

system(avlcmd);

%Move output files
tot_forc=sprintf('Out_Force_%.0f.txt',i);
%movefile(tot_forc,'C:/Users/Joe/OneDrive - University of Bristol/Documents/GitHub/APSOptimiser/Outputs/Forces'); %/\/\/\/\
fclose('all');
movefile(tot_forc,'Outputs/Forces')

stab_deri=sprintf('Stab_Deri_%.0f.txt',i);
%movefile(stab_deri,'C:/Users/Joe/OneDrive - University of Bristol/Documents/GitHub/APSOptimiser/Outputs/Stability'); %/\/\/\/\
fclose('all');
movefile(stab_deri,'Outputs/Stability');

% Move plot file
%filename=sprintf('geom_%.0f.ps',i);
%movefile('plot.ps',filename)
%movefile(filename,'Outputs/Plots/Geometry')


outname=tot_forc;

end

