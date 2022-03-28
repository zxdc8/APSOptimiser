function [CoM_X_Disp, CoM_Y_Disp, CoM_Z_Disp, Seg_Mass, Vol_Seg, Wing_Pos] = MassPoints(Struc_Mass, filename)

fid = fopen(filename);
tline = fgetl(fid);
X_Pos = [];
Y_Pos = [];
Z_Pos = [];
Chord = [];
FoilA = [];
while ischar(tline)
    tline = fgetl(fid);
    string_line = string(tline);
    
        if string_line == string('SECTION') %Reads the dimensional components of the aerofoil in the line following the SECTION phrase
            tline = fgetl(fid);
            string_line = string(tline);
            panel_values = double(split(string_line));
            X_Pos = [X_Pos panel_values(1)]; %following lists contain the respective attribute of all the Aerofoils after the loop
            Y_Pos = [Y_Pos panel_values(2)];
            Z_Pos = [Z_Pos panel_values(3)];
            Chord = [Chord panel_values(4)];
        elseif string_line == string(' NACA') || string_line == string('NACA') %Reads the NACA foil number of each aerofoil
            tline = fgetl(fid);
            NACA_Unit = string(tline);
            FoilA = [FoilA NACA_Unit]; %List contains the NACA no. for each aerofoil of the .avl file
        end
        
end
fclose(fid);

Wing_Pos(1,:) = X_Pos;
Wing_Pos(2,:) = Y_Pos;
Wing_Pos(3,:) = Z_Pos;
Wing_Pos(4,:) = Chord;

%Run through the list of Segment NACA Foils, if a new foil no. comes up
%then add to a list that sends the specific no's through the Foil function 
Foil_No = unique(str2double(FoilA));

for i = [1:length(Foil_No)]
    [NACA_Area, Cen_X, Cen_Y] = Foil_Integral( Foil_No(i) ); %Finds the relative area to a 1m chord of the Aerofoil NACA no.
    NACA_Unit(i,1) = Foil_No(i);
    NACA_Unit(i,2) = NACA_Area;
    NACA_Unit(i,3) = Cen_X;
    NACA_Unit(i,4) = Cen_Y;
end


for i = [1:length(X_Pos)-1]
    %fun = @(x) (Chord(i)^2 * FoilA1 - ( (Chord(i)^2 * FoilA1 - Chord(i+1)^2*FoilA2) /5).*x)
    %Below lines check for the saved NACA foil areas and call upon them during the segment volume calculation
    fun = @(x) (Chord(i)^2 .* str2double(NACA_Unit( find(Foil_No == str2double(FoilA(i))) ,2)) ...
        - ( (Chord(i)^2 .* str2double(NACA_Unit( find(Foil_No == str2double(FoilA(i))) ,2)) ...
        - Chord(i+1)^2 .* str2double(NACA_Unit( find(Foil_No == str2double(FoilA(i+1))) ,2)) ) / (Y_Pos(i+1)-Y_Pos(i)) ).*x);
    
    Vol_Seg(i) = integral(fun, 0, Y_Pos(i+1)-Y_Pos(i)); 
    
    
    %Below Lines use quadratic and Linear Distirbution of Segemnt Masses to find Displacment of the Segments x-component 
    %from the segments forwardmost aerofoil 
    x = [ 0:0.01: (Y_Pos(i+1)-Y_Pos(i)) ];
    K = cumtrapz(( Chord(i+1) ^2 - Chord(i) ^2)/ (Y_Pos(i+1)-Y_Pos(i)) ^2.* x.^2 + Chord(i)^2); %use of cumulative distribution finds halfway centre of mass value
    below = find(K < K(end)/2);

    X_A = Chord(i)*str2double(NACA_Unit( find(Foil_No == str2double(FoilA(i))) ,3));
    X_B = (Chord(i+1)*str2double(NACA_Unit( find(Foil_No == str2double(FoilA(i))) ,3)) ... %CoM displacement
        - Chord(i)*str2double(NACA_Unit( find(Foil_No == str2double(FoilA(i))) ,3))) ...
        /(Y_Pos(i+1)-Y_Pos(i))*x(below(end)); 
    X_C = (X_Pos(i+1)-X_Pos(i))/(Y_Pos(i+1)-Y_Pos(i))*x(below(end)); %Aerofoil displacement

    CoM_X_Shift(i) = X_A + X_B + X_C; %CoM from Segments' forwardmost aerofoil
    CoM_X_Disp(i) = CoM_X_Shift(i) + X_Pos(i); %CoM from 0 X- axis 
    CoM_Y_Disp(i) = x(below(end)) + Y_Pos(i); %CoM from 0 Y-axis
    CoM_Z_Disp(i) = tan( (Z_Pos(i+1)-Z_Pos(i))/(Y_Pos(i+1)-Y_Pos(i)) )*x(below(end)) + Z_Pos(i); %CoM from 0 Z-axis
    
end
Vol = 2*sum(Vol_Seg); %Total Volume of wing Structure

Vol_Dens = Struc_Mass/Vol; %Theoretical Density of Segments - Not strucutrally concerned 
Seg_Mass = Vol_Seg * Vol_Dens;

CoM_x = sum( CoM_X_Disp.*Seg_Mass)/sum(Seg_Mass);

end







