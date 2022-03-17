function CL=LiftCalc(M,At)


    [~,a,~,rho]=atmosisa(11582.4);
    CL=(300e3*9.81)/(0.5*rho*At*(M*a)^2);


end