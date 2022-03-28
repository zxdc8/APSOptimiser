%AVL calling tester%
function tot_forc = AVLcall(avl,mass,run,i)
%define command file
cmdfile=fopen('commandfile.txt','w');

% load input files, disable graphics, enter run window
% fprintf(cmdfile,'LOAD %s\nMASS %s\nCASE %s\n',avl,mass,run);
fprintf(cmdfile,'LOAD %s\nMASS %s\n',avl,mass);
fprintf(cmdfile,'mset\n0\n');
fprintf(cmdfile,'OPER\nX\n');

% Initialise, run, get forces
tot_forc=sprintf('Tot_Forc_%.0f.txt',i);
stab_deri=sprintf('Stab_Deri_%.0f.txt',i);

<<<<<<< HEAD
fprintf(cmdfile,'FT\n%s\n',tot_forc);
fprintf(cmdfile,'ST\n%s\n',stab_deri);
=======
fprintf(cmdfile,'FT\n%s\nO\n',tot_forc);
fprintf(cmdfile,'ST\n%s\nO\n',stab_deri);
>>>>>>> abf7b881a385c434dba1d9ee54ad87c6fc9aad7b

% Exit
fprintf(cmdfile,'\nquits');

fclose(cmdfile);

system('avl < commandfile.txt');

end

