function [ccL, cM] = loads(A_root, A_tip, c_root, c_tip, lambda_1, lambda_2, J,...
    theta_root, theta_kink, theta_tip, W_fuel_c, W_wing_c)
%% Un-normalize
    for i = 1:12
        A_root(i,1) = A_root(i,1) * initial_values(i);
        A_tip(i,1) = A_tip(i,1) * initial_values(i+12);
    end 
    c_root = c_root * initial_values(25);
    c_tip = c_tip * initial_values(26);
    lambda_1 = lambda_1 * initial_values(27);
    lambda_2 = lambda_2 * initial_values(28);
    J = J * initial_values(29);
    theta_root = theta_root * initial_values(30);
    theta_kink = theta_kink * initial_values(31);
    theta_tip = theta_tip * initial_values(32);
    W_fuel_c = W_fuel_c * initial_values(35);
    W_wing_c = W_wing_c * initial_values(36);

%% Get Kinky
    global kink;
    KinkCST = kink.CST;
    
    x_kink = 10.36/tand(90-lambda_1);
    x_tip = x_kink + (J-10.36)/(tand(90-lambda_2));
    c_kink = c_root - x_kink + 0.02;

%% Normal Q3D stuff
    % Wing planform geometry 
    %                x    y     z   chord(m)    twist angle (deg) 
    AC.Wing.Geom = [0, 0, 0, c_root, theta_root;
                    x_kink, 10.36, 0, c_kink, theta_kink;
                    x_tip, J, 0, c_tip, theta_tip];

    % Wing incidence angle (degree)
    AC.Wing.inc  = 0;   


    % Airfoil coefficients input matrix
    %                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
    AC.Wing.Airfoils   = [A_root(1), A_root(2), A_root(3), A_root(4), A_root(5), A_root(6),...
                          A_root(7), A_root(8), A_root(9), A_root(10), A_root(11), A_root(1);
                          KinkCST(1),KinkCST(2), KinkCST(3), KinkCST(4), KinkCST(5), KinkCST(6),...
                          KinkCST(7), KinkCST(8), KinkCST(9), KinkCST(10), KinkCST(11), KinkCST(12);
                          A_tip(1), A_tip(2), A_tip(3), A_tip(4), A_tip(5), A_tip(6),...
                          A_tip(7), A_tip(8), A_tip(9), A_tip(10), A_tip(11), A_tip(12)];

    kink_location = 10.36/J;
    AC.Wing.eta = [0;kink_location;1];  % Spanwise location of the airfoil sections

    % Viscous vs inviscid
    AC.Visc  = 0;              % 0 for inviscid and 1 for viscous analysis

    % Flight Condition
    AC.Aero.V     = 262.48;            % flight speed (m/s)
    AC.Aero.rho   = 0.4397;         % air density  (kg/m3)
    AC.Aero.alt   = 9500;             % flight altitude (m)
    tr = (c_tip/c_root);
    MAC = (2/3) * c_root*(1+tr+tr^2)/(1+tr);
    mu = 1.475e-5;
    AC.Aero.Re    = (AC.Aero.rho * AC.Aero.V * MAC)/(mu);        % reynolds number (bqased on mean aerodynamic chord)
    AC.Aero.M     = 0.87;           % flight Mach number
    q = 0.5*AC.Aero.rho*AC.Aero.V^2;
    S = 2*(0.5*(c_root+c_kink)*10.36 + 0.5*(c_kink+c_tip)*(J-10.36));
    base_weight = 154.44e3;
    WTO_max = W_fuel_c + W_wing_c + base_weight;
    AC.Aero.CL    = (2.5*WTO_max*9.81)/(q*S);          % lift coefficient - comment this line to run the code for given alpha%
    %AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

    Res = Q3D_solver(AC);

%% Write EMWET .load file for next run 
    AS.Y = linspace(0,1,8);
    AS.L = interp1(Res.Wing.Yst,Res.Wing.ccl*q,AS.Y*J,'spline'); %lift distribution
    AS.T = interp1(Res.Wing.Yst,Res.Wing.cm_c4.*Res.Wing.chord*q*MAC,AS.Y*J,'spline'); % pitching moment distribution
    
    fid = fopen('MD11.load', 'wt');  
    for i=1:length(AS.Y)
        fprintf(fid,'%g %g %g\n',AS.Y(i),AS.L(i),AS.T(i));
    end
    fclose(fid);
        
    ccL = AS.L;
    cM = AS.T;
end