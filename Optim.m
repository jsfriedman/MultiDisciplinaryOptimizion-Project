function [f] = Optim(x)
    % set design variables equal to design variables from the
    A_root = x(1:12);
    A_tip = x(13:24);
    c_root = x(25);
    c_tip = x(26);
    lambda_1 = x(27);
    lambda_2 = x(28);
    J = x(29);
    theta_root = x(30);
    theta_kink = x(31);
    theta_tip = x(32);
    L_c = x(33);
    D_c = x(34);
    W_fuel_c = x(35);
    W_wing_c = x(36);
    ccL1_c = x(37);
    ccL2_c = x(38);
    ccL3_c = x(39);
    ccL4_c = x(40);
    ccL5_c = x(41);
    ccL6_c = x(42);
    ccL7_c = x(43);
    ccL8_c = x(44);
    cM1_c = x(45);
    cM2_c = x(46);
    cM3_c = x(47);
    cM4_c = x(48);
    cM5_c = x(49);
    cM6_c = x(50);
    cM7_c = x(51);
    cM8_c = x(52);
    
    % evaluate the disciplines
    W_wing = weight();
    
    [L, D] = aero(A_root, A_tip,c_root, c_tip, lambda_1, lambda_2, J,...
                  theta_root, theta_kink, theta_tip, W_fuel_c, W_wing_c);
              
    [ccL, cM] = loads(A_root, A_tip,c_root, c_tip, lambda_1, lambda_2, J,...
                  theta_root, theta_kink, theta_tip, W_fuel_c, W_wing_c);
    
    W_fuel = performance(W_fuel_c,W_wing_c,L_c,D_c);
    
        
    % evaluate the objective function
    f = objective(W_fuel);
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
    couplings.ccL1 = ccL(1);
    couplings.ccL2 = ccL(2);
    couplings.ccL3 = ccL(3);
    couplings.ccL4 = ccL(4);
    couplings.ccL5 = ccL(5);
    couplings.ccL6 = ccL(6);
    couplings.ccL7 = ccL(7);
    couplings.ccL8 = ccL(8);
    couplings.cM1 = cM(1);
    couplings.cM2 = cM(2);
    couplings.cM3 = cM(3);
    couplings.cM4 = cM(4);
    couplings.cM5 = cM(5);
    couplings.cM6 = cM(6);
    couplings.cM7 = cM(7);
    couplings.cM8 = cM(8);
    couplings.ccL1_c = ccL1_c;
    couplings.ccL2_c = ccL2_c;
    couplings.ccL3_c = ccL3_c;
    couplings.ccL4_c = ccL4_c;
    couplings.ccL5_c = ccL5_c;
    couplings.ccL6_c = ccL6_c;
    couplings.ccL7_c = ccL7_c;
    couplings.ccL8_c = ccL8_c;
    couplings.cM1_c = cM1_c;
    couplings.cM2_c = cM2_c;
    couplings.cM3_c = cM3_c;
    couplings.cM4_c = cM4_c;
    couplings.cM5_c = cM5_c;
    couplings.cM6_c = cM6_c;
    couplings.cM7_c = cM7_c;
    couplings.cM8_c = cM8_c;
end