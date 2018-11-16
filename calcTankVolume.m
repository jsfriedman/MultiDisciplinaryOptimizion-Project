function [V_tank] = calcTankVolume(x) 
    c_root = x(25);
    c_tip = x(26);
    lambda1 = x(27);
    J = x(29);

    global kink;
    Xt_r = kink.x_root_upper;
    Xl_r = kink.x_root_lower;
    Xt_k = kink.x_kink_upper;
    Xl_k = kink.x_kink_lower;
    Xt_tk = kink.x85_upper;
    Xl_tk = kink.x85_lower;
    
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