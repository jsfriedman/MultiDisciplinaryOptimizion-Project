close all;clc

A_root = [0.1739;0.2814;0.2007;0.3183;0.1761;0.2942;...
          -0.1026;-0.1127;-0.2200;0.0312;-0.0651;0.1376];
A_tip  = [0.1146;0.1969;0.1106;0.2567;0.1245;0.2606;...
          -0.0434;-0.0282;-0.1299;0.0928;-0.0135;0.1712];
c_root = 15.5;
c_tip = 3.75;
lambda1 = 35;
lambda2 = 35;
J = 25.9;
theta_root = 0;
theta_kink = 0;
theta_tip = 0;      
      
% [KinkCST,Xt_r,Xl_r,Xt_k,Xl_k,Xt_t,Xl_t,Xt_tk,Xl_tk] = AFinterp(A_root,A_tip,J);

c_kink = c_root - 10.36/tand(90-lambda1) + 0.02;

% x_r = [0 0 0];
% x_k = [10.36/tand(90-lambda1) 10.36 0];
% x_t = [10.36/tand(90-lambda1)+(J-10.36)/tand(90-lambda2) J 0];
% 
% A_wing = 0.5*(c_root+c_kink)*10.36 + 0.5*(c_kink+c_tip)*(J-10.36);

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

% figure
% hold on
% plot(Xt_root(:,1),Xt_root(:,2),'b',Xl_root(:,1),Xl_root(:,2),'b')
% plot(Xt_kink(:,1),Xt_kink(:,2),'g',Xl_kink(:,1),Xl_kink(:,2),'g')
% plot(Xt_tank(:,1),Xt_tank(:,2),'r',Xl_tank(:,1),Xl_tank(:,2),'r')

% diff = zeros(1,length(Xt_root(:,1)));
% for i = 1:length(Xt_root(:,1))
%     diff(i) = Xt_root(i,2)-Xl_root(i,2);
% end
% mroot = max(diff)/c_root;
% 
% diff = zeros(1,length(Xt_root(:,1)));
% for i = 1:length(Xt_root(:,1))
%     diff(i) = Xt_kink(i,2)-Xl_kink(i,2);
% end
% mkink = max(diff)/c_kink;
% 
% diff = zeros(1,length(Xt_root(:,1)));
% for i = 1:length(Xt_root(:,1))
%     diff(i) = Xt_tank(i,2)-Xl_tank(i,2);
% end
% mtank = max(diff)/c_tank;

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
     
