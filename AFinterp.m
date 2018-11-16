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