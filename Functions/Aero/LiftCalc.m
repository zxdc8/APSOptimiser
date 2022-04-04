%/////Works out required CL and writes to run file//////
function CL=LiftCalc(M,At,CD0)
    
    %Calculate required Cl for Wing Area
    [T,a,~,rho]=atmosisa(11582.4);
    CL=(300e3*9.81)/(0.5*rho*At*(M*a)^2);
    
    %Also work out reynolds number
    
    DynVisc=14.23e-6;
    c=(80^2)/At;
    Re= (rho*a*M*c)/DynVisc;
    
    %Create Run File
%     pth='././Inputs';
    f = fullfile('C:','Users','Joe','OneDrive - University of Bristol','Documents','GitHub','APSOptimiser','Inputs');
    filename=sprintf('w.run');
    %gfile=fopen('././Inputs/w.run','w');

    gfile=fopen(fullfile(f,filename),'w');


    fprintf(gfile,['\n-------------------------\nRun     case   1:       Cruise\n\n' ...
        'alpha        ->  CL          =  %.6f\n'],CL);
    fprintf(gfile,['beta         ->  beta        =   0.00000   \n' ...
        'pb/2V        ->  pb/2V       =   0.00000\n' ...
        'qc/2V        ->  qc/2V       =   0.00000\n' ...
        'rb/2V        ->  rb/2V       =   0.00000\n\n']);

    fprintf(gfile,'CL   =   %.4f\n',CL);
    fprintf(gfile,'CDo   =   %.2f\n',CD0);
    fprintf(gfile,'velocity   =   %.2f\n',M*a);
    fprintf(gfile,'density  =   %.2f\n',rho);


    fclose(gfile);

end