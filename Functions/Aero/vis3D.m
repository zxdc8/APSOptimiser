function [] = vis3D(X)

    [S,X,Z,dih]=DesignToSXZ(X)

    %% NEW METHOD-CONVEX HULL
    %Generate a wing geometry
    %Import NACA aerofoil
    NACA=table2array(readtable('././Inputs/NACA23012.txt'))
    len=length(NACA);

    %GENERATE 3D WING POINTS
    foil3D=zeros(len,3);

    for ii=1:length(Z)
        
        tmpfoil=NACA*S(ii);
        tmpfoil(:,1)=tmpfoil(:,1)+X(ii);
        tmpfoil(:,3)=Z(ii);

    if ii==1

        foil3D=tmpfoil;

    else

        foil3D=vertcat(foil3D,tmpfoil);

    end       
    end

    %SEPARATE INTO WING AND FUSELAGE
    Fus3D=foil3D(1:2*len,:);
    Wing3D=foil3D(len+1:3*len,:);


%     xmin=min(foil3D(:,1));
%     xmax=max(foil3D(:,1));
% 
%     ymin=min(foil3D(:,2));
%     ymax=max(foil3D(:,2));

%     [XX,YY] = meshgrid(linspace(xmin,xmax,1000),linspace(ymin,ymax,1000))
% 
%     XYZ=griddata(foil3D(:,1),foil3D(:,2),foil3D(:,3),XX,YY)

    %FIND CONVEX HULL VOLUME FOR FUSELAGE AND WING
    [kF, VF]=convhull(Fus3D(:,1),Fus3D(:,2),Fus3D(:,3),'Simplify',true);

    [kW, VW]=convhull(Wing3D(:,1),Wing3D(:,2),Wing3D(:,3),'Simplify',true);

    figure
    trisurf(kF,Fus3D(:,1),Fus3D(:,3),Fus3D(:,2),'Facecolor','cyan','Edgecolor','none')
    hold all
    trisurf(kW,Wing3D(:,1),Wing3D(:,3),Wing3D(:,2),'Facecolor','cyan','Edgecolor','none')
    hold all
    trisurf(kF,Fus3D(:,1),-Fus3D(:,3),Fus3D(:,2),'Facecolor','cyan','Edgecolor','none')
    hold all
    trisurf(kW,Wing3D(:,1),-Wing3D(:,3),Wing3D(:,2),'Facecolor','cyan','Edgecolor','none')
    axis equal
   
    %camlight
    lightangle(-45,70)

    %Multiply volumes by two for each wing
    VF=2*VF;
    VW=2*VW;
    
    %Estimate Volume of a Passenger
    Vpas=1.5*0.79*0.43;
    Npas=468;
    
    VP=Vpas*Npas;



end