close all
clear all

span=readmatrix('Logging/zvariation.csv');
xpos=readmatrix('Logging/xvariation.csv');


xc=10:30
yc=40-xc;

figure
subplot(2,2,1)
contourf(10:40,10:40,span,50)
title('Span Sensitivity')
xlabel('Z(Root->Mid)')
ylabel('Z(Mid->Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);
hold all
plot(xc,yc,'g','LineWidth',2.0);
plot(10:40,10*ones(31,1),'r','LineWidth',2.0);
plot(10:40,30*ones(31,1),'r','LineWidth',2.0);
plot(10*ones(31,1),10:40,'r','LineWidth',2.0);
plot(30*ones(31,1),10:40,'r','LineWidth',2.0);
plot(10,30,'*m','MarkerSize',20.0,'Linewidth',2.0)
legend('','Span Constraint','LB/UB','','','','Optimum')


subplot(2,2,2)
surf(10:40,10:40,span)
title('Span Sensitivity')
xlabel('Z(Root->Mid)')
ylabel('Z(Mid->Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);

subplot(2,2,3)
contourf(0:30,0:30,xpos,50)
title('Fore/Aft Sensitivity')
xlabel('X(Mid)')
ylabel('X(Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);
hold all
%plot(1:31,0*ones(31,1),'r','LineWidth',2.0);
%plot(1:31,40*ones(31,1),'r','LineWidth',2.0);
%plot(40*ones(31,1),1:31,'r','LineWidth',2.0);
%plot(72*ones(31,1),1:31,'r','LineWidth',2.0);
plot(0.252,1.7516,'*m','MarkerSize',20.0,'Linewidth',2.0)
legend('','Optimum')


subplot(2,2,4)
surf(0:30,0:30,xpos)
title('Fore/Aft Sensitivity')
xlabel('X(Mid)')
ylabel('X(Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);