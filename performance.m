function [W_fuel] = performance(W_fuel_c, W_wing_c, L_c, D_c)
    
    L_c = L_c * initial_values(33);
    D_c = D_c * initial_values(34);
    W_fuel_c = W_fuel_c * initial_values(37);
    W_wing_c = W_wing_c * initial_values(38);
    
    R = 12569.5e3; % m
    CT = 1.8639e-4; % N/Ns
    V = 243; % m/s
    base_weight = 154.44e3;
    WTO_max = W_fuel_c + W_wing_c + base_weight;
    W_fuel = WTO_max * (1-( 1 / (0.938*( exp((CT*R*D_c)/(V*L_c))))));
end