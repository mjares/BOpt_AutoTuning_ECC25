%mass [kg]
m = 25;

%gravity [m/s²]
g = 9.81; 

%weight [N]
W = m*g;

%volume [L]
vol = 0.02432;

%fluid constant
rho = 1028;

%bouyance force [N]
B = -vol*g*rho;

%center of bouyance w.r.t. the center of the body [m]
r_b = [0; 0; -0.08];

%center of gravity w.r.t. the center of the body [m]
r_g = [0; 0; 0.02];

%inertia moment around the x_b axis [kg m²]
I_x = 0.379;

%inertia moment around the y_b axis [kg m²]
I_y = 0.300;

%inertia moment around the z_b axis [kg m²]
I_z = 0.517;

%inertia matrix
I_b = diag([I_x; I_y; I_z]);

%hydrodynamic added mass force in x direction due to acceleration
%in surge axis [kg]
X_u_dot = -5.5;

%hydrodynamic added mass force in y direction due to acceleration
%in sway axis [kg]
Y_v_dot = -12.7;

%hydrodynamic added mass force in z direction due to acceleration
%in heave axis [kg]
Z_w_dot = -14.57;

%hydrodynamic added mass torque in p rotation due to acceleration
%in roll [kg m²/rad]
K_p_dot = -0.12;

%hydrodynamic added mass torque in q rotation due to acceleration
%in pitch [kg m²/rad]
M_q_dot = -0.12;

%hydrodynamic added mass torque in r rotation due to acceleration
%in yaw [kg m²/rad]
N_r_dot = -0.12;

%linear damping in surge direction [Ns/m]
X_u = -4.03;

%linear damping in sway direction [Ns/m]
Y_v = -6.22;

%linear damping in heave direction [Ns/m]
Z_w = -5.18;

%linear damping around roll [Ns/rad]
K_p = -0.07;

%linear damping around pitch [Ns/rad]
M_q = -0.07;

%linear damping around yaw [Ns/r
N_r = -0.07;

%quadratic damping in surge direction [Ns²/m²]
X_u_u = -18.18;

%quadratic damping in sway direction [Ns²/m²]
Y_v_v = -21.66;

%quadratic damping in heave direction [Ns²/m²]
Z_w_w = -5.18;

%quadratic damping around roll [Ns²/rad²]
K_p_p = -1.55;

%quadratic damping around pitch [Ns²/rad²]
M_q_q = -1.55;

%quadratic damping around yaw [Ns²/rad²]
N_r_r = -1.55;

Smtrx_r_g = [0 -r_g(3) r_g(2); ... 
             r_g(3) 0 -r_g(1); ... 
            -r_g(2) r_g(1) 0];  

m_M = [m*eye(3) -m*Smtrx_r_g; ...
     m*Smtrx_r_g I_b];

%Vehicle added mass matrix
Ma = -diag([X_u_dot; Y_v_dot; Z_w_dot; K_p_dot; M_q_dot; N_r_dot]);

Dlf = -[X_u; ...
       Y_v; ...
       Z_w; ...
       K_p; ...
       M_q; ...        
       N_r];
        
Dqf = -[X_u_u; ...
       Y_v_v; ...
       Z_w_w; ...
       K_p_p; ...
       M_q_q; ...
       N_r_r];

%========================= Displacement limitations of the vehicle ========
         
thruster_const = 0.00031877;

max_surge_acc = 0.2;%[m/s²]
max_sway_acc = 0.2; %[m/s²]
max_heave_acc = 0.2; %[m/s²]

max_surge_vel = 0.8; %[m/s]
max_sway_vel = 0.8; %[m/s]
max_heave_vel = 0.8; %[m/s]

min_surge_acc = -0.2; %[m/s²]
min_sway_acc = -0.2; %[m/s²]
min_heave_acc = -0.2; %[m/s²]

min_surge_vel = -0.8; %[m/s]
min_sway_vel = -0.8; %[m/s]
min_heave_vel = -0.8; %[m/s]

max_roll_acc = deg2rad(10); %[rad/s²]
max_pitch_acc = deg2rad(10); %[rad/s²]
max_yaw_acc = deg2rad(10); %[rad/s²]

max_roll_vel = deg2rad(30); %[rad/s]
max_pitch_vel = deg2rad(30); %[rad/s]
max_yaw_vel = deg2rad(30); %[rad/s]

min_roll_acc = -max_roll_acc; %[rad/s²]
min_pitch_acc = -max_pitch_acc; %[rad/s²]
min_yaw_acc = -max_yaw_acc; %[rad/s²]

min_roll_vel = -max_roll_vel; %[rad/s]
min_pitch_vel = -max_pitch_vel; %[rad/s]
min_yaw_vel = -max_yaw_vel; %[rad/s]

%========================= Actuator Module variables ======================

qty_actuators = 8;

thrust_sup = ones(qty_actuators, 1)*51.48; %[N] OG_repo: 40; Paper:51.48
thrust_inferior = ones(qty_actuators, 1)*(-39.91); %[N] OG_repo: 38, Paper: 39.91

actuators_tconst = ones(qty_actuators, 1)*0.1754; %[s] OG_repo: 0.017, Paper: 0.1754

%========================= Allocation matrix creation =====================

%Thrusters orientation wrt body, when body is considered a frame in at the 
%center of the vehicle written in right hand rule
thrusters_ori_wrt_body = [0 0 -45; 0 0 45; 0 0 -135; 0 0 135; 0 -90 0; 
                          0 -90 0; 0 -90 0; 0 -90 0;];

%transforming the orientation of the thrusters from angle to quaternion
thrusters_ori_wrt_body_quat = angle2quat(deg2rad(thrusters_ori_wrt_body(:,1))', ...
                            deg2rad(thrusters_ori_wrt_body(:,2))', ...
                             deg2rad(thrusters_ori_wrt_body(:,3))', 'XYZ')';
    

    
             
thrusters_ori_wrt_sname_quat = thrusters_ori_wrt_body_quat;          
                                    
%transformation from rhl to sname convention in quaternion
quat_b2s = angle2quat(pi, 0, 0, 'XYZ')';


%writting the thrusters orientation with respect to the sname frame using
%quaternions
for i=1:1:size(thrusters_ori_wrt_body_quat, 2)

    thrusters_ori_wrt_sname_quat(:,i) = quat_mult([quat_b2s(1); -quat_b2s(2:4)], thrusters_ori_wrt_body_quat(:,i));
    
end

thrusters_ori_wrt_sname = thrusters_ori_wrt_body;

%transforming the thrusters orientation w.r.t. the sname frame into angles
[thrusters_ori_wrt_sname(:,1), thrusters_ori_wrt_sname(:,2), thrusters_ori_wrt_sname(:,3)] = ...
    quat2angle(thrusters_ori_wrt_sname_quat', 'XYZ');
 

%transforming the angles into degrees
thrusters_ori_wrt_sname = rad2deg(thrusters_ori_wrt_sname);
                                     
%Thrusters position wrt body, when body is considered a frame in at the 
%center of the vehicle written in right hand rule
thrusters_pos_wrt_body_rhl =  [0.12766 -0.12059 0.02496; ...
                               0.12766  0.12059 0.02496; ...
                              -0.17022 -0.120 0.02496; ...
                              -0.17022 0.120 0.02496; ...
                               0.10841 -0.2335 0.08348; ...
                               0.10841  0.2335 0.08348; ...
                              -0.132  -0.2335 0.08348; ...
                              -0.132  0.2335 0.08348;];
 
%transformation from rhl to sname convention using roll DCM                          
DCM_roll = [1 0 0; 0 cos(pi) -sin(pi); 0 sin(pi) cos(pi)];

thrusters_pos_wrt_body_sname =  DCM_roll*thrusters_pos_wrt_body_rhl';

thrusters_ori_wrt_body = [0 0 45; 0 0 -45; 0 0 135; 0 0 -135; 0 -90 0; 0 -90 0; 0 -90 0; 0 -90 0;];

% Creating the control effectiveness matrix
thruster_effectiveness_matrix = ...
    calculate_6DoF_fixed_allocation_matrix_deg(thrusters_ori_wrt_body, thrusters_pos_wrt_body_sname');
% Control Allocation Matrix
control_allocation_matrix = thruster_effectiveness_matrix'/...
    (thruster_effectiveness_matrix*thruster_effectiveness_matrix'); 
%==================== Thruster Faults =====================================
thruster_effectiveness_matrix = thruster_effectiveness_matrix * ...
                             thruster_effectiveness;
if reallocate_control == 1
     control_allocation_matrix = thruster_effectiveness_matrix'/...
    (thruster_effectiveness_matrix*thruster_effectiveness_matrix'); 
end
