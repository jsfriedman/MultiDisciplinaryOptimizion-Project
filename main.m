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
 %x0(1:24) = initial_values(1:24);
 x0(27:28) = 35/100;
 x0(30:32) = 0;

%% Bounds

lower_bounds_normalized = [0.840713053479011;0.859985785358920;0.790234180368710;0.909833490417845;
                           0.863145939806928;0.946974847042828;0.730994152046784;0.649511978704525;
                           0.809090909090909;0.0801282051282051;0.629800307219662;0.886627906976744;
                           0.862129144851658;0.886236668359573;0.782097649186257;0.936501753019088;
                           0.888353413654619;0.965848042977744;0.635944700460830;0.202127659574468;
                           0.814472671285604;0.823275862068966;-0.0222222222222222;0.948014018691589;
                           0.8;0.773333333333333;0.0778*3.6;0.0778*3.6;0.772200772200772;-0.0417*3.6;-0.0417*3.6;
                           -0.0417*3.6;0.8;0.8;0.704805079107322;0.788049233375855;0.8;0.8;0.8;0.8;
                           0.8;0.8;0.8;0.800000000000000;0.800000000000000;0.800000000000000;
                           0.800000000000000;0.800000000000000;0.800000000000000;0.800000000000000;
                           0.800000000000000;0.800000000000000];
  
upper_bounds_normalized = [1.15871190339275;1.14036958066809;1.20926756352765;1.09048067860509;
                           1.13628620102215;1.05336505778382;1.26900584795322;1.34960070984916;
                           1.19136363636364;1.92307692307692;1.37019969278034;1.11409883720930;
                           1.13787085514834;1.11477907567293;1.21699819168174;1.06427736657577;
                           1.11004016064257;1.03453568687644;1.36175115207373;1.80141843971631;
                           1.18475750577367;2.04956896551724;2.01481481481481;1.05257009345794;
                           1.20000000000000;1.20000000000000;0.116700000000000*3.6;0.116700000000000*3.6;
                           1.35135135135135;0.0417000000000000*3.6;0.0417000000000000*3.6;0.0417000000000000*3.6;
                           1.20000000000000;1.20000000000000;1.69153218985757;1.20670038860678;1.20000000000000;
                           1.20000000000000;1.20000000000000;1.20000000000000;1.20000000000000;1.20000000000000;
                           1.20000000000000;1.20000000000000;1.20000000000000;1.20000000000000;1.20000000000000;
                           1.20000000000000;1.20000000000000;1.20000000000000;1.20000000000000;1.20000000000000];


                           
                           
%% Initial Constraint Values


%% Optimization Options
options.Display         = 'iter';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 1e-2;         % Minimum change while gradient searching
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
