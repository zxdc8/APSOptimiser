close all
clear all

span=readmatrix('Logging/zvariation.csv');
xpos=readmatrix('Logging/xvariation.csv');

figure
subplot(2,2,1)
contourf(span,50)
title('Span Sensitivity')
xlabel('Z(Root->Mid)')
ylabel('Z(Mid->Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);

subplot(2,2,2)
surf(span)
title('Span Sensitivity')
xlabel('Z(Root->Mid)')
ylabel('Z(Mid->Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);

subplot(2,2,3)
contourf(xpos,50)
title('Fore/Aft Sensitivity')
xlabel('X(Mid)')
ylabel('X(Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);

subplot(2,2,4)
surf(xpos)
title('Fore/Aft Sensitivity')
xlabel('X(Mid)')
ylabel('X(Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);