function [V_tank] = calcTankVolume(x) 
    A_root = x(1:12);
    A_tip  = x(13:24);
    c_root = x(25);
    c_tip = x(26);
    lambda1 = x(27);
    J = x(29);

    [~,Xt_r,Xl_r,Xt_k,Xl_k,~,~,Xt_tk,Xl_tk] = AFinterp(A_root,A_tip,J);

    c_kink = c_root - 10.36/tand(90-lambda1) + 0.02;

    spar_front = 0.15;
    spar_back = 0.6;
    front = find(Xt_r(:,1) == spar_front);
    back = find(Xt_r(:,1) == spar_back);

    c_tank = c_kink - (c_kink-c_tip)*(0.85*J-10.36)/(J-10.36);

    Xt_root = c_root*Xt_r;
    Xl_root = c_root*Xl_r;
    Xt_kink = c_kink*Xt_k;
    Xl_kink = c_kink*Xl_k;
    Xt_tank = c_tank*Xt_tk;
    Xl_tank = c_tank*Xl_tk;

    t_root_front = Xt_root(front,2)-Xl_root(front,2);
    t_root_back = Xt_root(back,2)-Xl_root(front,2);
    t_kink_front = Xt_kink(front,2)-Xl_kink(front,2);
    t_kink_back = Xt_kink(back,2)-Xl_kink(back,2);
    t_tank_front = Xt_tank(front,2)-Xl_tank(front,2);
    t_tank_back = Xt_tank(back,2)-Xl_tank(back,2);

    A_root = 0.5*(t_root_front+t_root_back)*(spar_back-spar_front)*c_root;
    A_kink = 0.5*(t_kink_front+t_kink_back)*(spar_back-spar_front)*c_kink;
    A_tank = 0.5*(t_tank_front+t_tank_back)*(spar_back-spar_front)*c_tank;

    V_tank = (1/3)*10.36*(A_root + A_kink + sqrt(A_root*A_kink)) + ...
             (1/3)*(0.85*J-10.36)*(A_kink + A_tank + sqrt(A_kink*A_tank));
end
     

function[KinkCST,Xt_r,Xl_r,Xt_k,Xl_k,Xt_t,Xl_t,Xt_85,Xl_85] = AFinterp(RootCST,TipCST,J)

    A_root = RootCST;
    A_tip = TipCST;
    M = 12;
    M_break=M/2;
    X_vect = linspace(0,1,101)';      %points for evaluation along x-axis
    [Xt_root,Xl_root]=D_airfoil2(A_root(1:M_break),A_root(1+M_break:end),X_vect);
    [Xt_tip,Xl_tip]=D_airfoil2(A_tip(1:M_break),A_tip(1+M_break:end),X_vect);

    Xt_kink = Xt_root;
    Xl_kink = Xl_root;
    Xt_kink(:,2) = Xt_root(:,2) - (10.36/J)*(Xt_root(:,2)-Xt_tip(:,2));
    Xl_kink(:,2) = Xl_tip(:,2) + (1-10.36/J)*(Xl_root(:,2)-Xl_tip(:,2));

    global couplings;
    couplings.Xt_kink = Xt_kink;
    couplings.Xl_kink = Xl_kink;

    %Define optimization parameters
    x0 = 0*ones(M,1);     %initial value of design vector x(starting vector for search process)
    lb = -1*ones(M,1);    %upper bound vector of x
    ub = 1*ones(M,1);     %lower bound vector of x
    
    %% Optimization Options
    options.Display         = 'off';
    options.Algorithm       = 'sqp';
    options.FunValCheck     = 'on';
    options.DiffMinChange   = 1e-6;         % Minimum change while gradient searching
    options.DiffMaxChange   = 5e-2;         % Maximum change while gradient searching
    options.TolCon          = 1e-6;         % Maximum difference between two subsequent constraint vectors [c and ceq]
    options.TolFun          = 1e-6;         % Maximum difference between two subsequent objective value
    options.TolX            = 1e-6;         % Maximum difference between two subsequent design vectors
    options.MaxIter         = 1e3;          % Maximum iterations

    %perform optimization
    [x,~,~] = fmincon(@CST_objective_kink,x0,[],[],[],[],lb,ub,[],options);


    Xt_tank = Xt_root;
    Xl_tank = Xl_root;
    Xt_tank(:,2) = Xt_root(:,2) - 0.85*(Xt_root(:,2)-Xt_tip(:,2));
    Xl_tank(:,2) = Xl_tip(:,2) + 0.15*(Xl_root(:,2)-Xl_tip(:,2));

    KinkCST = x;
    Xt_r = Xt_root;
    Xl_r = Xl_root;
    Xt_k = Xt_kink;
    Xl_k = Xl_kink;
    Xt_t = Xt_tip;
    Xl_t = Xl_tip;
    Xt_85 = Xt_tank;
    Xl_85 = Xl_tank;
end
