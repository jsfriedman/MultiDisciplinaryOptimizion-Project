function [c,ceq] = constraints(x)
% design variables, x, need to be passed in to constraints function for
% fmincon to work
global couplings;

%% Inequality constraints
% transform to the form of "0 >= [whatever was greater than zero]"
c_fueltank = W_fuel - (0.81715e3 * calcTankVolume(x) * 0.93);

%% Equality constraints

%% consistency constraints
lift_consistency = L-L_c;
drag_consistency = D-D_c;
ccL_consistency = ccL - ccL_c;
cM_consistency = cM - cM_c;
wingweight_consistency = W_weight - W_weight_c;
fuelweight_consistency = W_fuel - W_fuel_c;

%% formatting answers for fmincon
c = [c_fueltank];
ceq = [lift_consistency, drag_consistency, ccL_consistency,...
    cM_consistency, wingweight_consistency ,fuelweight_consistency];
end