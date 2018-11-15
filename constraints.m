function [c,ceq] = constraints(x)
% design variables, x, need to be passed in to constraints function for
% fmincon to work
global couplings;
L = couplings.L;
L_c = couplings.L_c;
D = couplings.D;
D_c = couplings.D_c;
W_wing = couplings.W_wing;
W_wing_c = couplings.W_wing_c;
W_fuel = couplings.W_fuel;
W_fuel_c = couplings.W_fuel_c;
ccL = couplings.ccL;
ccL_c = couplings.ccL_c;
cM = couplings.cM;
cM_c = couplings.cM_c;

%% Inequality constraints
% transform to the form of "0 >= [whatever was greater than zero]"
c_fueltank = W_fuel - (0.81715e3 * calcTankVolume(x) * 0.93);

%% Equality constraints

%% consistency constraints
lift_consistency = L-L_c;
drag_consistency = D-D_c;
ccL_consistency = ccL - ccL_c;
cM_consistency = cM - cM_c;
wingweight_consistency = W_wing - W_wing_c;
fuelweight_consistency = W_fuel - W_fuel_c;

%% formatting answers for fmincon
c = [c_fueltank];
ceq = [lift_consistency, drag_consistency, ccL_consistency,...
    cM_consistency, wingweight_consistency ,fuelweight_consistency];
end