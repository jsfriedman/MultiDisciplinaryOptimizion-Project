function [c,ceq] = constraints(x)
    % design variables, x, need to be passed in to constraints function for
    % fmincon to work
    global couplings;
    L = couplings.L / initial_values(33);
    L_c = couplings.L_c;
    D = couplings.D / initial_values(34);
    D_c = couplings.D_c;
    W_wing = couplings.W_wing / initial_values(36);
    W_wing_c = couplings.W_wing_c;
    W_fuel = couplings.W_fuel / initial_values(35);
    W_fuel_c = couplings.W_fuel_c;
    ccL1 = couplings.ccL1 / initial_values(37);
    ccL2 = couplings.ccL2 / initial_values(38);
    ccL3 = couplings.ccL3 / initial_values(39);
    ccL4 = couplings.ccL4 / initial_values(40);
    ccL5 = couplings.ccL5 / initial_values(41);
    ccL6 = couplings.ccL6 / initial_values(42);
    ccL7 = couplings.ccL7 / initial_values(43);
    ccL8 = couplings.ccL8 / initial_values(44);
    cM1 = couplings.cM1 / initial_values(45);
    cM2 = couplings.cM2 / initial_values(46);
    cM3 = couplings.cM3 / initial_values(47);
    cM4 = couplings.cM4 / initial_values(48);
    cM5 = couplings.cM5 / initial_values(49);
    cM6 = couplings.cM6 / initial_values(50);
    cM7 = couplings.cM7 / initial_values(51);
    cM8 = couplings.cM8 / initial_values(52);
    ccL1_c = couplings.ccL1_c;
    ccL2_c = couplings.ccL2_c;
    ccL3_c = couplings.ccL3_c;
    ccL4_c = couplings.ccL4_c;
    ccL5_c = couplings.ccL5_c;
    ccL6_c = couplings.ccL6_c;
    ccL7_c = couplings.ccL7_c;
    ccL8_c = couplings.ccL8_c;
    cM1_c = couplings.cM1_c;
    cM2_c = couplings.cM2_c;
    cM3_c = couplings.cM3_c;
    cM4_c = couplings.cM4_c;
    cM5_c = couplings.cM5_c;
    cM6_c = couplings.cM6_c;
    cM7_c = couplings.cM7_c;
    cM8_c = couplings.cM8_c;

    %% Inequality constraints
    % transform to the form of "0 >= [whatever was greater than zero]"
    c_fueltank = couplings.W_fuel - (0.81715e3 * calcTankVolume(x) * 0.93);

    %% Equality constraints

    %% consistency constraints
    lift_consistency = L-L_c;
    drag_consistency = D-D_c;
    ccL1_consistency = ccL1 - ccL1_c;
    ccL2_consistency = ccL2 - ccL2_c;
    ccL3_consistency = ccL3 - ccL3_c;
    ccL4_consistency = ccL4 - ccL4_c;
    ccL5_consistency = ccL5 - ccL5_c;
    ccL6_consistency = ccL6 - ccL6_c;
    ccL7_consistency = ccL7 - ccL7_c;
    ccL8_consistency = ccL8 - ccL8_c;
    cM1_consistency = cM1 - cM1_c;
    cM2_consistency = cM2 - cM2_c;
    cM3_consistency = cM3 - cM3_c;
    cM4_consistency = cM4 - cM4_c;
    cM5_consistency = cM5 - cM5_c;
    cM6_consistency = cM6 - cM6_c;
    cM7_consistency = cM7 - cM7_c;
    cM8_consistency = cM8 - cM8_c;
    wingweight_consistency = W_wing - W_wing_c;
    fuelweight_consistency = W_fuel - W_fuel_c;

    %% formatting answers for fmincon
    c = [c_fueltank];
    ceq = [lift_consistency, drag_consistency, ccL1_consistency,...
        ccL2_consistency,ccL3_consistency,ccL4_consistency,ccL5_consistency,ccL6_consistency,ccL7_consistency,ccL8_consistency,...
        cM1_consistency,cM2_consistency,cM3_consistency,cM4_consistency,cM5_consistency,cM6_consistency,cM7_consistency,cM8_consistency,...
        wingweight_consistency ,fuelweight_consistency];
end