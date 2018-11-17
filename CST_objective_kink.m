function[error] = CST_objective_kink(x)
%Determine upper and lower CST parameters from design-vector
 Au = x(1:length(x)/2);
 Al = x(length(x)/2+1:length(x));

global couplings;
Xt = couplings.Xt_kink;
Xl = couplings.Xl_kink;

X_u = Xt(:,1);
X_l = Xl(:,1);
Y_u = Xt(:,2);
Y_l = Xl(:,2);

%Perform mapping of CST method twice, for both upper (Au) and lower (Al) surface 
%CST parameters; use corresponding upper and lower surface x-ordinates from E553 
[Co_CST_up, Co_discard] = D_airfoil2(Au,Al,X_u);
[Co_discard2, Co_CST_low] = D_airfoil2(Au,Al,X_l);

%upper and lower partial fiting-error vectors
error_up = Y_u - Co_CST_up(:,2);
error_low = Y_l - Co_CST_low(:,2);

%final objective value
error = sum(error_up.^2) + sum(error_low.^2);