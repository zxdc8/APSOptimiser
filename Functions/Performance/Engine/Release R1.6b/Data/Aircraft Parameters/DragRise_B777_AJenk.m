function dCdW = DragRise_B777_AJenk(Cl, M)
% dCdW = DragRiseData(Cl, M)

if nargin < 1
    M = [1.1 0.76 0.8];
    Cl = [1.1 1.11 0.7];
end

M_vec =            [0.70	0.76	0.78	0.8 1]+0.06;
%       Cl Drag Rise Data
data = [0.00	0.0     0       0.0     0.0
    0.05	0.0     0       0.0     0.0
    0.10	0.0     0       0.0     0.0
    0.15	0.0     0       0.0     0.2
    0.20	0.0     0       0.0     0.5
    0.25	0.0     0       0.0     1.0
    0.30	0.0     0       0.0     2.0
    0.35	0.0     0       0.0     3.5
    0.40	0.0     0       0.0     5.0
    0.45	0.0     0       1.0     7.0
    0.50	0.0     0       2.0     9.5
    0.55	0.0     1       3.5     13.0
    0.60	0.0     2.5     5.0     18.0
    0.65	1.0     5       8.0     25.0
    0.70	4.00	8       11.0	32.0
    1       10      20      30      100];

Cl_vec  = data(:,1);
CdW_data = [data(:,2:end) data(:,end)*2] *0.0001;

dCdW = interp2(Cl_vec, M_vec, CdW_data',Cl,M,'linear',0);
end
