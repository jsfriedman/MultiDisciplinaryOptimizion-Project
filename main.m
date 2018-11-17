% Jonathan Friedman 4799380
% Jackson Horwitz [INSERT]
% AE4205 MDO for Aerospace, Final Project, 2018Q1

% This is intended to be the main file of the program. This might change as
% we go along.
clear variables;
clc;
% Run this file

%% Initial Values (including "guess" variables)

% initialize normalized values
 x0 = ones(52,1);
 x0(1:24) = initial_values(1:24);
 x0(27:28) = (35/360);
 x0(30:32) = 0;

%% Bounds

lower_bounds_normalized = [0.1462; 0.2420; 0.1586; 0.2896; 0.1520; 0.2786;
                           -0.1302; -0.1521; -0.2621; 0.0025; -0.0892; 0.1220;
                           0.0988; 0.1745; 0.0865; 0.2404; 0.1106; 0.2517;
                           -0.0591; -0.0508; -0.1539; 0.0764; -0.0272; 0.1623;
                           0.8;0.773333333333333; 0.0778; 0.0778; 0.772200772200772;
                           -0.0417; -0.0417; -0.0417; 0.8;0.8;
                           0.704805079107322;0.788049233375855;
                           0.8;0.8;0.8;0.8;0.8;0.8;0.8;0.8; 
                           0.8;0.8;0.8;0.8;0.8;0.8;0.8;0.8];
  
upper_bounds_normalized = [0.2015; 0.3209; 0.2427; 0.3471; 0.2001; 0.3099;
                          -0.0750; -0.0732; -0.1780; 0.0600; -0.0410; 0.1533;
                          0.1304; 0.2195; 0.1346; 0.2732; 0.1382; 0.2696;
                          -0.0276; -0.0057; -0.1058; 0.1902; 0.0003; 0.1802;
                           1.2;1.2; 0.1167; 0.1167; 1.35135135135135;
                           0.0417;0.0417;0.0417;1.2;1.2;
                           1.69153218985757;1.20670038860678;
                           1.2;1.2;1.2;1.2;1.2;1.2;1.2;1.2;
                           1.2;1.2;1.2;1.2;1.2;1.2;1.2;1.2];

%% Initial Constraint Values


%% Optimization Options
options.Display         = 'iter';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 1e-4;         % Minimum change while gradient searching
options.DiffMaxChange   = 5e-2;         % Maximum change while gradient searching
options.TolCon          = 1e-3;         % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-3;         % Maximum difference between two subsequent objective value
options.TolX            = 1e-3;         % Maximum difference between two subsequent design vectors
options.MaxIter         = 1e3;          % Maximum iterations
options.PlotFcns        = {@optimplotfval, @optimplotx, @optimplotfirstorderopt};


%% Global Variables
    % add all of the variables that have "guess" copies as globals. maybe
    % also add all design variables?
global couplings;
couplings.L_c = initial_values(33);
couplings.D_c = initial_values(34);
couplings.W_wing_c = initial_values(35);
couplings.W_fuel_c = initial_values(36);
couplings.ccL1_c = initial_values(37);
couplings.ccL2_c = initial_values(38);
couplings.ccL3_c = initial_values(39);
couplings.ccL4_c = initial_values(40);
couplings.ccL5_c = initial_values(41);
couplings.ccL6_c = initial_values(42);
couplings.ccL7_c = initial_values(43);
couplings.ccL8_c = initial_values(44);
couplings.cM1_c = initial_values(45);
couplings.cM2_c = initial_values(46);
couplings.cM3_c = initial_values(47);
couplings.cM4_c = initial_values(48);
couplings.cM5_c = initial_values(49);
couplings.cM6_c = initial_values(50);
couplings.cM7_c = initial_values(51);
couplings.cM8_c = initial_values(52);

%% fmincon
[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@Optim,x0,[],[],[],[],lower_bounds_normalized,upper_bounds_normalized,@constraints,options);
