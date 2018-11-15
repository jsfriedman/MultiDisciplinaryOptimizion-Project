function [f] = Optim(x)
    % set design variables equal to design variables from the 
    root_upper1 = x(1); 
    root_upper2 = x(2);
    root_upper3 = x(3);
    root_upper4 = x(4);
    root_upper5 = x(5);
    root_upper6 = x(6);
    root_lower1 = x(7); 
    root_lower2 = x(8);
    root_lower3 = x(9);
    root_lower4 = x(10);
    root_lower5 = x(11);
    root_lower6 = x(12);
    tip_upper1 = x(13); 
    tip_upper2 = x(14);
    tip_upper3 = x(15);
    tip_upper4 = x(16);
    tip_upper5 = x(17);
    tip_upper6 = x(18);
    tip_lower1 = x(19); 
    tip_lower2 = x(20);
    tip_lower3 = x(21);
    tip_lower4 = x(22);
    tip_lower5 = x(23);
    tip_lower6 = x(24);
    c_root = x(25);
    c_tip = x(26);
    lambda_1 = x(27);
    lambda_2 = x(28);
    J = x(29);
    theta_root = x(30);
    theta_kink = x(31);
    theta_tip = x(32);
    W_fuel = x(33);
    W_wing = x(34);
    L = x(35);
    D = x(36);
    ccL = x(37);
    cM = x(38);
    L_c = x(39);
    D_c = x(40);
    ccL_c = x(41);
    cM_c = x(42);
    W_fuel_c = x(43);
    W_wing_c = x(44);
    
    % evaluate the disciplines
    [L, D] = aero(); % INCOMPLETE
    [ccL, cM] = loads();  %INCOMPLETE
    W_wing = weight(); % INCOMPLETE
    W_fuel = performance(W_fuel_c,W_wing_c,L_c,D_c);
    
    % evaluate the objective function
    f = objective(W_fuel);
    % evaluate constraints
    [c,ceq] = constraints(x);
    
    % update global vars
    global couplings;
    couplings.L = L;
    couplings.L_c = L_c;
    couplings.D = D;
    couplings.D_c = D_c;
    couplings.W_wing = W_wing;
    couplings.W_wing_c = W_wing_c;
    couplings.W_fuel = W_fuel;
    couplings.W_fuel_c = W_fuel_c;
    couplings.ccL = ccL;
    couplings.ccL_c = ccL_c;
    couplings.cM = cM;
    couplings.cM_c = cM_c;
end