function BWB_Mass_Graph(Wing_Pos, CoM_Pass, CoM_Fuel, CoM_X_Disp, CoM_Y_Disp)

X_Pos = Wing_Pos(1,:);
Y_Pos = Wing_Pos(2,:);
Chord = Wing_Pos(4,:);

CoM_X_Pass = CoM_Pass(1,:);
CoM_Y_Pass = CoM_Pass(2,:);

CoM_X_Fuel = CoM_Fuel(1,:);
CoM_Y_Fuel = CoM_Fuel(2,:);

Spar_Clear = 1;
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
for c = [3:4]
    plot( [X_Pos(c) X_Pos(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'g-', 'linewidth', 0.5)
    plot( [X_Pos(c)+Chord(c) X_Pos(c+1)+Chord(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'g-', 'linewidth', 0.5)
    
    plot( CoM_X_Fuel(c-2), CoM_Y_Fuel(c-2), 'gx', 'markersize', 10)
end

X_Pos = (X_Pos + [Spar_Clear Spar_Clear Spar_Clear 0 0]);
Chord = Chord - 2*Spar_Clear;
for c = [1:2]
    plot( [X_Pos(c) X_Pos(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'r-', 'linewidth', 2)
    plot( [X_Pos(c)+Chord(c) X_Pos(c+1)+Chord(c+1)], [Y_Pos(c) Y_Pos(c+1)], 'r-', 'linewidth', 2)
    
    plot( CoM_X_Pass(c), CoM_Y_Pass(c), 'rx', 'markersize', 10)
end

end