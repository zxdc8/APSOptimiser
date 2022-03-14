%///////CALLS AVL/////////
function outname = AVLcall(avl,run,i)
%define command file
cmdfile=fopen('.\.\commandfile.txt','w');

%load input files, disable graphics, enter run window
fprintf(cmdfile,'LOAD Inputs/AVLcases/%s\nCASE Inputs/%s\nPLOP\nGF\n\nOPER\n',avl,run);

%Initialise, run, get forces
outname=sprintf('out_%.0f.txt',i);
fprintf(cmdfile,'#\nX\nFT\n%s\n',outname);

%Plot Geometry
fprintf(cmdfile,'G\nV\n0 90\nH\n');

% %Exit
% fprintf(cmdfile,'\nquits');

fclose(cmdfile);

system('avl < commandfile.txt');

%Move output file
filename=sprintf('out_%.0f.txt',i);
movefile(filename,'Outputs/Forces');


%Move plot file
filename=sprintf('geom_%.0f.ps',i)
movefile('plot.ps',filename)
movefile(filename,'Outputs/Plots/Geometry')

outname=sprintf('out_%.0f.txt',i);

end

