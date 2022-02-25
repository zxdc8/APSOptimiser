%AVL calling tester%
function outname = AVLcall(avl,run,i)
%define command file
cmdfile=fopen('commandfile.txt','w');

%load input files, disable graphics, enter run window
fprintf(cmdfile,'LOAD %s\nCASE %s\nPLOP\nGF\n\nOPER\n',avl,run);

%Initialise, run, get forces
outname=sprintf('out_%.0f.txt',i)
fprintf(cmdfile,'#\nX\nFT\n%s\nO\n',outname)

%Exit
fprintf(cmdfile,'\nquits')

fclose(cmdfile);

system('avl < commandfile.txt')

end

