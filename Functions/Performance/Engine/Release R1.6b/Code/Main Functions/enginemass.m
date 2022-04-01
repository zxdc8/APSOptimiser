function Meng = enginemass(SF)


BareEng = 1464; %kg


%% Weight Engine
Meng = BareEng*SF;%kg
Mmount = Meng*0.4;%kg
Mpylon = (Meng+Mmount)*0.2; %kg

Meng = 3*(Meng+Mmount+Mpylon);

end