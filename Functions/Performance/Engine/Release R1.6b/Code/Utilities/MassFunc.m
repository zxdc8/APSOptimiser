function [m_fuel] = MassFunc(m_ramp, m_to, m_owe, m_pl, m_res, m_approach)
% MassFunc
% 
% Inputs:
% m_ramp = Ramp Mass
% m_to = Take-off Mass
% m_owe = Operational Weight Empty
% m_pl = Design Payload Mass
% m_res = Reserve Mass
% 
% 
% Mass of the fuel required for the range
m_fuel = m_ramp - m_owe - m_pl - m_res;

% Mass at Touch Down
m_td = m_owe + m_pl + m_res;

% Mass at end of descent
m_approach
m_enddes = m_td + m_approach;
end





    
    