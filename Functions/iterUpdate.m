%/////UPDATE ITERATION//////
function i=iterUpdate()
    
    filename='iteration.csv';
    ifile=fopen(filename,'r');
    
    LastIteration=table2array(readtable(filename));
    iter=LastIteration;
    
    fclose(ifile);
    
    ifile=fopen(filename,'w');
    fprintf(ifile,'%i',1+iter);
    fclose(ifile);

end