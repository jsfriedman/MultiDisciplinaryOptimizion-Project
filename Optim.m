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
    ccL_c = x(35);
    cM_c = x(36);
    W_fuel_c = x(37);
    W_wing_c = x(38);
    
    % evaluate the disciplines
    W_wing = weight();
    
    [L, D] = aero(A_root, A_tip,c_root, c_tip, lambda_1, lambda_2, J,...
                  theta_root, theta_kink, theta_tip, W_fuel_c, W_wing_c);
              
    [ccL, cM] = loads(A_root, A_tip,c_root, c_tip, lambda_1, lambda_2, J,...
                  theta_root, theta_kink, theta_tip, W_fuel_c, W_wing_c);
    
    W_fuel = performance(W_fuel_c,W_wing_c,L_c,D_c);
    
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
    
    % evaluate the objective function
    f = objective(W_fuel);
    % evaluate constraints
    [c,ceq] = constraints(x);
   
end