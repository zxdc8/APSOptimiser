%% Define test run to view
%Outputs graph for wing, conversion, ranges of particles and outputs.
close all
clear all

n = 4;

%% Load in variables

pathfile1 =sprintf('././Logging/X_%.0f.mat',n);
pathfile2 =sprintf('././Logging/V_%.0f.mat',n);
%Iteraiton and Particle position
load(pathfile1)
load(pathfile2)

iterations = length(X2);

%Final solution
pathfile3 =sprintf('././Logging/Output_%.0f.mat',n);
load(pathfile3)

%Range of X values
pathfile4 =sprintf('././Logging/Ranges_%.0f.mat',n);
load(pathfile4)

%% Graphs
%convergence of range of particles
figure
hold all
plot(1:iterations,Range.X,'x-')
plot(1:iterations,Range.V,'x-')
xlabel('Iteration');
ylabel('Design Variables Range');
legend('Summed Position Range','Summed Velocity Range')
grid on

%Convergence of results
Val = zeros(iterations,1);
X3 = X2{1};
[Val(1)] = min(X3(:,8));
Obj = Val;
for kk = 2:iterations
    
    X3 = X2{kk};
    
    [Val(kk)] = min(X3(:,8));
    
    
    if Val(kk)> Obj(kk-1)
        Obj(kk) = Obj(kk-1);
       
    else
        Obj(kk) = Val(kk);
    end
end

% Obj = sort(Val,'descend');
% 


figure
hold on
grid on
xlabel('Iteration')
ylabel('Current Best Function Value')
plot(1:iterations,Obj,'r*')
    b = "Best Function Value:";
    b2 = num2str(round(Output.Fuel));
    b3 = join([b b2]);
    title(b3)
ylim([30e3 90e3])

vis3D(Output.Geometry)



