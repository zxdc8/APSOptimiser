%//////GET ITERATION///////%
function i = getIteration()

    filename='iteration.csv';
    
    ifile=fopen(filename,'r');
    
    i=table2array(readtable(filename));

end