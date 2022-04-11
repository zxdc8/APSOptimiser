function [CoM_Array] = MassPayPoints(Np, Vol_Seg, Payload_Mass, Fuel_Mass, filename)

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
        end
end

Spar_Clear = 1; %m, distance of Passenger Cabin from TE & LE of Main Segments (1 & 2)
X_Pos_Array = [];
for mc = [1:length(X_Pos)] %Loop creates an array needed for finding Passenger Cabin sizing 
    if mc <= Np
        X_Pos_Array = [X_Pos_Array Spar_Clear];
    else
        X_Pos_Array = [X_Pos_Array 0];
    end
end

for mc = [1:length(X_Pos)-1]
    if mc <= (Np - 1)
        X_Pos = (X_Pos + X_Pos_Array);
        Chord = Chord - Spar_Clear*2;
        
        Area_Pass(mc) = area(polyshape( [ X_Pos(mc)+Chord(mc) X_Pos(mc+1)+Chord(mc+1) X_Pos(mc+1) X_Pos(mc)], [Y_Pos(mc) Y_Pos(mc+1) Y_Pos(mc+1) Y_Pos(mc)] ));
        [cx, cy] = centroid(polyshape( [ X_Pos(mc)+Chord(mc) X_Pos(mc+1)+Chord(mc+1) X_Pos(mc+1) X_Pos(mc)], [Y_Pos(mc) Y_Pos(mc+1) Y_Pos(mc+1) Y_Pos(mc)] ));
        CoM_Z_Pass(mc) = tan( (Z_Pos(mc+1)-Z_Pos(mc))/(Y_Pos(mc+1)-Y_Pos(mc)) )*cy;
        CoM_X_Pass(mc) = cx;
        CoM_Y_Pass(mc) = cy; 
        
        X_Pos = (X_Pos - X_Pos_Array);
        Chord = Chord + Spar_Clear*2;
    else
        Vol_Fuel(mc-(Np-1)) = Vol_Seg(mc);
        [cx, cy] = centroid(polyshape( [ X_Pos(mc)+Chord(mc) X_Pos(mc+1)+Chord(mc+1) X_Pos(mc+1) X_Pos(mc)], [Y_Pos(mc) Y_Pos(mc+1) Y_Pos(mc+1) Y_Pos(mc)] ));
        CoM_Z_Fuel(mc-(Np-1)) = tan( (Z_Pos(mc+1)-Z_Pos(mc))/(Y_Pos(mc+1)-Y_Pos(mc)) )*cy;
        CoM_X_Fuel(mc-(Np-1)) = cx;
        CoM_Y_Fuel(mc-(Np-1)) = cy; 
    end

end
    
CoM_Pass(1,:) = CoM_X_Pass;
CoM_Pass(2,:) = CoM_Y_Pass;
CoM_Pass(3,:) = CoM_Z_Pass;
for c = [1:length(CoM_Pass(1,:))]
    CoM_Pass(4,c) = Area_Pass(c)/sum(Area_Pass)*Payload_Mass/2;
end
CoM_Fuel(1,:) = CoM_X_Fuel;
CoM_Fuel(2,:) = CoM_Y_Fuel;
CoM_Fuel(3,:) = CoM_Z_Fuel;
for c = [1:length(CoM_Fuel(1,:))]
    CoM_Fuel(4,c) = Vol_Fuel(c)*71;
end

CoM_Array{1} = CoM_Pass;
CoM_Array{2} = CoM_Fuel;

end



