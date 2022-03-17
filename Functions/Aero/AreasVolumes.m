function [VF,VW,VP] = AreasVolumes(S,X,Z,dih)

      
    %Estimate Cross Sectional Areas
    %For NACA 2412, say area is Chord*0.12*0.75
    ANACA=S.*0.12.*0.75;

    %Estimate volume
    VF=2*0.5*(ANACA(1)+ANACA(2)).*Z(2);   %Fuselage Area (PAX) for 2 wings
    VW=2*0.5*(ANACA(2)+ANACA(3)).*(Z(3)-Z(2));   %Wing ares (FUEL) for 2 wings

    
    %Estimate Volume of a Passenger
    Vpas=1.5*0.79*0.43;
    Npas=468;
    
    VP=Vpas*Npas;


end