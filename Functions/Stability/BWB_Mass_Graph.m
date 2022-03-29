function BWB_Mass_Graph(Np, Wing_Pos, CoM_Pass, CoM_Fuel, CoM_X_Disp, CoM_Y_Disp)

X_Pos = Wing_Pos(1,:);
Y_Pos = Wing_Pos(2,:);
Chord = Wing_Pos(4,:);

CoM_X_Pass = CoM_Pass(1,:);
CoM_Y_Pass = CoM_Pass(2,:);

CoM_X_Fuel = CoM_Fuel(1,:);
CoM_Y_Fuel = CoM_Fuel(2,:);

%% Create Array for passenger cabin sizing calculation
Spar_Clear = 1; %m, distance of Passenger Cabin from TE & LE of Main Segments (1 & 2)
X_Pos_Array = [];
for mc = [1:length(X_Pos)] %Loop creates an array needed for finding Passenger Cabin sizing 
    if mc <= Np
        X_Pos_Array = [X_Pos_Array Spar_Clear];
    else
        X_Pos_Array = [X_Pos_Array 0];
    end
end

%% Plot out LE & TE of BWB Wing and Mass points of components
figure
hold on

for c = [1:length(X_Pos)]
    plot( [X_Pos(c) X_Pos(c)+Chord(c)], [Y_Pos(c) Y_Pos(c)], 'b-', 'linewidth', 2)
end
for c = [1:length(X_Pos)-1]
    plot( [X_Pos(c) X_Pos(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'b-', 'linewidth', 3)
    plot( [X_Pos(c)+Chord(c) X_Pos(c+1)+Chord(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'b-', 'linewidth', 3)
    
    plot( CoM_X_Disp(c), CoM_Y_Disp(c), 'bx', 'markersize', 10)
end
for c = [Np:length(X_Pos)-1]
    plot( [X_Pos(c) X_Pos(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'g-', 'linewidth', 0.5)
    plot( [X_Pos(c)+Chord(c) X_Pos(c+1)+Chord(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'g-', 'linewidth', 0.5)
    
    plot( CoM_X_Fuel(c-(Np-1)), CoM_Y_Fuel(c-(Np-1)), 'gx', 'markersize', 10)
end

X_Pos = (X_Pos + X_Pos_Array);
Chord = Chord - 2*Spar_Clear;
for c = [1:(Np-1)]
    plot( [X_Pos(c) X_Pos(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'r-', 'linewidth', 2)
    plot( [X_Pos(c)+Chord(c) X_Pos(c+1)+Chord(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'r-', 'linewidth', 2)
    
    plot( CoM_X_Pass(c), CoM_Y_Pass(c), 'rx', 'markersize', 10)
end

end