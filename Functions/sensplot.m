close all
clear all

span=readmatrix('./Logging/zvariationc.csv');
xpos=readmatrix('./Logging/xvariation.csv');
xcon=readmatrix('./Logging/xvariationc.csv');
scale=readmatrix('./Logging/svariationc.csv');
taper=readmatrix('./Logging/Tvariation.csv');


%Apply fore aft constraint
xcon(xcon<10e5);

xconx=(70/size(xcon,2))*(1:14);
yconx=(70/size(xcon,2))*([0 1 2 3 4 5 6 7 8 9 10 11 12 12])

xconx2=ones

%%
close all
xc=10:2:30;
yc=40-xc;

xs=10:2:40;
ys=10:2:40;

xx=0:5:70;
yx=0:5:70;

xsc=20:2.5:70;
ysc=15:2.5:70;

xt=5:0.5:15;

figure

Contours=[30 36 38 39 40 41 42 43 45 50 60 70 80 100]*1e3;

[C,h]=contour(xs,ys,span,Contours);
clabel(C,h)
title('Span Sensitivity')
ylabel('Z_{Root->Mid}/m')
xlabel('Z_{Mid->Tip}/m')
c=colorbar;
ylabel(c,'J','Rotation',0);
hold all
plot(xc,yc,'g','LineWidth',2.0);
% plot(xs,10*ones(length(xs),1),'r','LineWidth',2.0);
% plot(xs,30*ones(length(xs),1),'r','LineWidth',2.0);
% plot(10*ones(length(xs),1),ys,'r','LineWidth',2.0);
% plot(30*ones(length(xs),1),ys,'r','LineWidth',2.0);
plot(29.605167800902674,10,'*m','MarkerSize',20.0,'Linewidth',2.0)
legend('','Span Constraint','Optimum')


figure
surf(xs,ys,span)
title('Span Sensitivity')
ylabel('Z_{Root->Mid}/m')
xlabel('Z_{Mid->Tip}/m')
c=colorbar;
ylabel(c,'J','Rotation',0);

Contours=[30 36 38 39 40.1 40.2 40.5 41 42 43 45 50 60 70 80 100]*1e3;
figure
[C,h]=contour(xx,yx,xcon,Contours);
clabel(C,h)
title('Fore/Aft Sensitivity')
ylabel('X_{Mid}/m')
xlabel('X_{Tip}/m')
c=colorbar;
ylabel(c,'J','Rotation',0);
hold all
%plot(xconx,yconx,'Linewidth',2.0)
%plot(1:31,0*ones(31,1),'r','LineWidth',2.0);
%plot(1:31,40*ones(31,1),'r','LineWidth',2.0);
%plot(40*ones(31,1),1:31,'r','LineWidth',2.0);
%plot(72*ones(31,1),1:31,'r','LineWidth',2.0);
plot(27.757912051431890,9.740143774296792,'*m','MarkerSize',20.0,'Linewidth',2.0)
legend('','Optimum')


figure
surf(xx,yx,xcon)
title('Fore/Aft Sensitivity')
ylabel('X_{Mid}/m')
xlabel('X_{Tip}/m')
c=colorbar;
ylabel(c,'J _(kg)','Rotation',0);

figure
[C,h]=contour(ysc,xsc,scale,Contours);
clabel(C,h)
title('Chord Sensitivity')
ylabel('Chord_{Root}/m')
xlabel('Chord_{Mid}/m')
c=colorbar;
ylabel(c,'J (kg)','Rotation',0);
hold all
plot(15,20.042808086131696,'*m','MarkerSize',20.0,'Linewidth',2.0)

figure
plot(xt,taper);
title('Tip Chord')
ylabel('J(kg)')
xlabel('Chord_{Tip}/m')
hold all
plot(5.004365913034243,40185,'*m','MarkerSize',20.0,'Linewidth',2.0)
grid on
legend('Optimum')


