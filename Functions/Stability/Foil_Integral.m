function [NACA_Area, Cen_X, Cen_Y] = Foil_Integral(NACA_Unit) %Ensure to give as string

Foil = num2str(NACA_Unit);

M = str2double(Foil(1))/100;  %Max Camber 
P = str2double(Foil(2))/10;   %Camber Position
T = str2double(Foil(3:4))/100;   %Thickness

y_t = @(x) T/0.2 * ( 0.2969.*sqrt(x) - 0.126.*x - 0.3516.*x.^2 + 0.2843.*x.^3 - 0.1015.*x.^4 );

y_c_int = @(x) M/P^2.*(2*P.*x - x.^2);  %This value for all values from 0 to P 
y_c_fin = @(x) M/(1-P)^2.*( 1-2*P + 2*P.*x - x.^2 );  %This value for all values from P to Chord (1m always) 

theta_int = @(x) atan( y_c_int(x)./x );  %Theta values for polar calculations within equations
theta_fin = @(x) atan( y_c_fin(x)./x );

Y_U_int = @(x) y_c_int(x) + y_t(x).*cos(theta_int(x)); %Y-function for each section with 
Y_U_fin = @(x) y_c_fin(x) + y_t(x).*cos(theta_fin(x));
Y_L_int = @(x) y_c_int(x) - y_t(x).*cos(theta_int(x));
Y_L_fin = @(x) y_c_fin(x) - y_t(x).*cos(theta_fin(x));

U_Int = abs(integral( Y_U_int, 0, P));  %Area of each Foil section
U_Fin = abs(integral( Y_U_int, P, 1));
L_Int = abs(integral( Y_L_int, 0, P));
L_Fin = abs(integral( Y_L_int, P, 1));

NACA_Area = (U_Int+U_Fin+L_Int+L_Fin)*10; %Total Area of NACA Foil

%% Find Centroid 
X_U_fin = @(x) x - y_t(x).*sin(theta_fin(x)); 
X_L_fin = @(x) x + y_t(x).*sin(theta_fin(x));  


X_Fun = @(x) x.*X_U_fin(x);
X(1) = integral( X_Fun, P, 1); %Finds CoM of relevant upper section, X
Y_Fun = @(x) x.*Y_U_fin(x);
Y(1) = integral( Y_Fun, P, 1); %Finds Y CoM coord

X_Fun = @(x) x.*X_L_fin(x);
X(2) = integral( X_Fun, P, 1); %Finds CoM of relevant lower section, X
Y_Fun = @(x) x.*Y_L_fin(x);
Y(2) = integral( Y_Fun, P, 1); %Finds Y CoM coord


Cen_X = (X(1)*U_Fin + X(2)*L_Fin)/(U_Fin + L_Fin);
Cen_Y = (Y(1)*U_Fin + Y(2)*L_Fin)/(U_Fin + L_Fin);

end