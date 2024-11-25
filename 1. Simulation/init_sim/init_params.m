%% ==================== Initial state of the vehicle ======================
init_vehicle_position = [0 0 0]'; %[x y z]' in [m]

init_vehicle_orientation_ang = [0 0 0]'; %[roll pitch yaw]' in [degree]

init_vehicle_orientation = eul2quat( ...
    deg2rad(init_vehicle_orientation_ang'), 'XYZ')';

init_vehicle_linear_vel = [0 0 0]'; %[u v w]' in [m/s];

init_vehicle_angular_vel = [0 0 0]'; %[p q r]' in [n.d.];

% const_water_current_vel = [0 0 0]'; %[c_u c_v c_w]' in [m/s]

%% ==================== Reference values of the guidance system ===========
ref_waypoints = Parameters.reference.path.waypoints;
no_waypoints = Parameters.reference.path.no_waypoints;
waypoint_thresh = Parameters.reference.path.waypoint_thresh;
last_waypoint_thresh = Parameters.reference.path.last_waypoint_thresh;
called_from_batch = Parameters.reference.called_from_batch;
path_ref_mask = Parameters.reference.path.reference_mask;
step_signal = Parameters.reference.step_signal;

if Parameters.reference.reference_type == "path"
    ref_switch = 0;
elseif Parameters.reference.reference_type == "step"
    ref_switch = 1;
end
%% ========================= PID Control Tunning ============================
% Asume controllers in the form u = Kp*e + Ki*\int{e} + Kd*de
% X
% Fine-tuned Nominal: [Kp, Ki, Kd] = [200, 8, 115].
% Y
% Fine-tuned Nominal: [Kp, Ki, Kd] = [200, 8, 115].
% Z
% Fine-tuned Nominal: [Kp, Ki, Kd] = [150, 0, 100].
% Roll
% Fine-tuned Nominal: [Kp, Ki, Kd] = [0.05, 0.5, 0.1].
% Pitch
% Fine-tuned Nominal: [Kp, Ki, Kd] = [0.05, 0.5, 0.1].
% Yaw
% Fine-tuned Nominal: [Kp, Ki, Kd] = [0.04, 0, 0.18].
PID_params = Parameters.controller;
% mdlWks = get_param("ROV_Simulator",'ModelWorkspace');
% assignin(mdlWks,'PID_params',PID_params)
%% ==================== Non-linear sampling frequency =====================
nlinear_sf = 400; %[Hz]
pos_sample_freq = 4; %[Hz]
%% ==================== Thruster Faults =======================
thruster_effectiveness = diag( ...
    Parameters.ctrl_alloc.thruster_effectiveness_vec);
reallocate_control = Parameters.ctrl_alloc.reallocate_control;
