close all
clear all

span=readmatrix('./Logging/zvariation.csv');
xpos=readmatrix('./Logging/xvariation.csv');


xc=10:2:30;
yc=40-xc;

xs=10:2:40;
ys=10:2:40;

xx=0:5:70;
yx=0:5:70;

figure
subplot(2,2,1)
contourf(xs,ys,span,50)
title('Span Sensitivity')
ylabel('Z(Root->Mid)')
xlabel('Z(Mid->Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);
hold all
plot(xc,yc,'g','LineWidth',2.0);
plot(xs,10*ones(length(xs),1),'r','LineWidth',2.0);
plot(xs,30*ones(length(xs),1),'r','LineWidth',2.0);
plot(10*ones(length(xs),1),ys,'r','LineWidth',2.0);
plot(30*ones(length(xs),1),ys,'r','LineWidth',2.0);
plot(29.605167800902674,10,'*m','MarkerSize',20.0,'Linewidth',2.0)
legend('','Span Constraint','LB/UB','','','','Optimum')


subplot(2,2,2)
surf(xs,ys,span)
title('Span Sensitivity')
ylabel('Z(Root->Mid)')
xlabel('Z(Mid->Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);

subplot(2,2,3)
contourf(xx,yx,xpos,50)
title('Fore/Aft Sensitivity')
ylabel('X(Mid)')
xlabel('X(Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);
hold all
%plot(1:31,0*ones(31,1),'r','LineWidth',2.0);
%plot(1:31,40*ones(31,1),'r','LineWidth',2.0);
%plot(40*ones(31,1),1:31,'r','LineWidth',2.0);
%plot(72*ones(31,1),1:31,'r','LineWidth',2.0);
plot(40,0,'*m','MarkerSize',20.0,'Linewidth',2.0)
legend('','Optimum')


subplot(2,2,4)
surf(xx,yx,xpos)
title('Fore/Aft Sensitivity')
ylabel('X(Mid)')
xlabel('X(Tip)')
c=colorbar;
ylabel(c,'J','Rotation',0);