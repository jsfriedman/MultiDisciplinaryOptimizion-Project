% Jonathan Friedman 4799380
% Jackson Horwitz [INSERT]
% AE4205 MDO for Aerospace, Final Project, 2018Q1

% This is intended to be the main file of the program. This might change as
% we go along.

% Run this file

%% Initial Values (including "guess" variables)

% initialize normalized values
 x0 = ones(38,1);
 x0(27:28) = (35/360);
 x0(30:32) = 0;
 x0(35) = ones(14,1);
 x0(36) = ones(14,1);

%% Bounds

ccL_lower = [140788.202445618;140266.410058812;138917.701515498;136767.311329001;
             133843.044457604;130182.179322374;125702.453685738;120518.136131394;
             115433.685014398;111737.964497978;108731.084167866;105190.083685518;
             101282.046193834;96950.4713337648;91990.5778932688;86189.5867334456;
             79225.2755496498;70032.3463428400;56929.4705465575;38215.7497188227];

cM_lower = [-466009.289908289;-442049.406971259;-415896.830467070;-388599.440565222;
            -361043.011695358;-333111.951781055;-305514.797068147;-276586.708675380;
            -243199.920804367;-216264.561684478;-196546.860669985;-179057.406157558;
            -163486.655464865;-149061.335980641;-134769.427240944;-119745.251524492;
            -102860.611834159;-82901.1386468944;-58639.9468552846;-28849.7537647737];
  
lower_bounds_normed = [0.840713053479011;0.859985785358920;0.790234180368710;0.909833490417845;
                       0.863145939806928;0.946974847042828;1.26900584795322;1.34960070984916;
                       1.19136363636364;0.0801282051282051;1.37019969278034;0.886627906976744;
                       0.862129144851658;0.886236668359573;0.782097649186257;0.936501753019088;
                       0.888353413654619;0.965848042977744;1.36175115207373;1.80141843971631;
                       1.18475750577367;0.823275862068966;2.01481481481481;0.948014018691589;
                       0.800000000000000;0.773333333333333; 0.0778; 0.0778; 0.772200772200772;
                       -0.0417; -0.0417; -0.0417; 0.800000000000000;0.800000000000000;ccL_lower;
                       cM_lower; 0.704805079107322;0.788049233375855];
 
ccL_upper = [211182.303668426;210399.615088218;208376.552273248;205150.966993501;
             200764.566686406;195273.268983560;188553.680528606;180777.204197092;
             173150.527521598;167606.946746966;163096.626251798;157785.125528276;
             151923.069290752;145425.707000647;137985.866839903;129284.380100168;
             118837.913324475;105048.519514260;85394.2058198363;57323.6245782341];
   
cM_upper = [-699013.934862433;-663074.110456889;-623845.245700604;-582899.160847834;
            -541564.517543036;-499667.927671583;-458272.195602221;-414880.063013070;
            -364799.881206551;-324396.842526718;-294820.291004977;-268586.109236336;
            -245229.983197297;-223592.003970961;-202154.140861416;-179617.877286738;
            -154290.917751239;-124351.707970342;-87959.9202829269;-43274.6306471605];
  
upper_bounds_normalized = [1.15871190339275;1.14036958066809;1.20926756352765;1.09048067860509;
                           1.13628620102215;1.05336505778382;0.730994152046784;0.649511978704525;
                           0.809090909090909;1.92307692307692;0.629800307219662;1.11409883720930;
                           1.13787085514834;1.11477907567293;1.21699819168174;1.06427736657577;
                           1.11004016064257;1.03453568687644;0.635944700460830;0.202127659574468;
                           0.814472671285604;2.04956896551724;-0.0222222222222222;1.05257009345794;
                           1.20000000000000;1.20000000000000; 0.1167; 0.1167; 1.35135135135135;
                           0.0417;0.0417;0.0417;1.20000000000000;1.20000000000000;ccL_upper;cM_upper;
                           1.69153218985757;1.20670038860678];

%% Initial Constraint Values


%% Optimization Options
options.Display         = 'iter-detailed';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 1e-6;         % Minimum change while gradient searching
options.DiffMaxChange   = 5e-2;         % Maximum change while gradient searching
options.TolCon          = 1e-6;         % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-6;         % Maximum difference between two subsequent objective value
options.TolX            = 1e-6;         % Maximum difference between two subsequent design vectors
options.MaxIter         = 1e3;          % Maximum iterations
options.PlotFcns        = {@optimplotfval, @optimplotx, @optimplotfirstorderopt};


%% Global Variables
    % add all of the variables that have "guess" copies as globals. maybe
    % also add all design variables?
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

%% fmincon
[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x) Optim(x),x0,[],[],[],[],lower_bounds_normalized,upper_bounds_normalized,@(x) constraints(x),options);
