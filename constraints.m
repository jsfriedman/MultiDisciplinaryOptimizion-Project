function [c,ceq] = constraints(x)
% design variables, x, need to be passed in to constraints function for
% fmincon to work
global couplings;
y1 = couplings.y1;
y2 = couplings.y2;
y1_c = couplings.y1_c;
y2_c = couplings.y2_c;

c1 = 3.16 - y1;
c2 = y2 - 24;
c_eq1 = y1-y1_c;
c_eq2 = y2-y2_c;
c = [c1,c2];
ceq = [c_eq1, c_eq2];
end