%/////Works out required CL and writes to run file//////
function CL=LiftCalc(M,At,CD0)
    
    %Calculate required Cl for Wing Area
    [~,a,~,rho]=atmosisa(11582.4);
    CL=(300e3*9.81)/(0.5*rho*At*(M*a)^2);

    %Create Run File
    pth='././Inputs';
    filename=sprintf('w.run');
    gfile=fopen(fullfile(pth,filename),'w');

    fprintf(gfile,['-------------------------\nRun case 1: Cruise\n' ...
        ' alpha        ->  CL      	  =   %.2f\n'],CL);
    fprintf(gfile,['beta         ->  beta        =   0.00000   ' ...
        'pb/2V        ->  pb/2V       =   0.00000\n' ...
        'qc/2V        ->  qc/2V       =   0.00000\n' ...
        'rb/2V        ->  rb/2V       =   0.00000\n\n']);

    fprintf(gfile,'CL   =   %.4f\n',CL);
    fprintf(gfile,'CDo   =   %.2f\n',CD0);
    fprintf(gfile,'velocity   =   %.2f\n',M*a);
    fprintf(gfile,'density  =   %.2f\n',rho);


    fclose(gfile);

end