function [W_fuel] = performance(W_fuel_c, W_wing_c, L_c, D_c)
    R = 12569.5e3; % m
    CT = 1.8639e-4; % N/Ns
    V = 243; % m/s
    WTO_max = W_fuel_c + W_wing_c + base_weight; % INCOMPLETE
    W_fuel = WTO_max * (1-( 1 / (0.938*( exp((CT*R*D_c)/(V*L_c))))));
end