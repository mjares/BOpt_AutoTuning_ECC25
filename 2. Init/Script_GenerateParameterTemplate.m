clear
clc
% Simulation
Parameters.sim_maxtime = 100;
% Reference
Parameters.reference.reference_type = "step";
Parameters.reference.step_signal = zeros(6, 1);
% Path
Parameters.reference.path.reference_mask = zeros(6, 1);
no_waypoints = 8;
Parameters.reference.path.no_waypoints = no_waypoints;
Parameters.reference.path.waypoints = zeros(6, no_waypoints);
Parameters.reference.path.waypoint_thresh = 0.2;
Parameters.reference.path.last_waypoint_thresh = 0.1;
Parameters.reference.called_from_batch = 0;
% Controllers
Parameters.controller = [0 0 0 ... % x
                         0 0 0 ... % y
                         0 0 0 ... % z
                         0 0 0 ... % roll
                         0 0 0 ... % pitch
                         0 0 0 ... % yaw
                        ];
% Parameters.controller = [249.955466911412	0.0115312368473873	130.571080904052 ... % x
%                          249.301772303715	0.000313111714481451	125.626100294409 ... % y
%                          154.968902350336	0.00354878844633992	104.983154011178 ... % z
%                          0.0592345204805809	2.99542605759997	0.0876475668567531 ... % roll
%                          0.196307554214101	2.22069756652544	0.235283671718461 ... % pitch
%                          0.718543071383211	4.48018949707132	0.382369103282610 ... % yaw
%                         ];
% Parameters.controller = [0 0 0 ... % x
%                          0 0 0 ... % y
%                          0 0 0 ... % z
%                          0.0592345204805809	2.99542605759997	0.0876475668567531 ... % roll
%                          0.196307554214101	2.22069756652544	0.235283671718461 ... % pitch
%                          0.718543071383211	4.48018949707132	0.382369103282610 ... % yaw
%                         ];
% Thrusters
Parameters.ctrl_alloc.reallocate_control = 0;
Parameters.ctrl_alloc.thruster_effectiveness_vec = [1,1,1,1,1,1,1,1];
% Optimization
Parameters.tuning.parameter_names = [   "kp_x"    "ki_x"    "kd_x" ... 
                                        "kp_y"    "ki_y"    "kd_y" ...
                                        "kp_z"    "ki_z"    "kd_z" ...
                                     "kp_roll" "ki_roll" "kd_roll" ...
                                     "kp_ptch" "ki_ptch" "kd_ptch" ...
                                      "kp_yaw"  "ki_yaw"  "kd_yaw" ...
                                      ];
Parameters.tuning.target_parameter = logical(...
                                     [0    0    0 ...
                                      0    0    0 ...
                                      0    0    0 ...
                                      0    0    0 ...
                                      0    0    0 ...
                                      0    0    0 ...
                                      ]);
Parameters.tuning.parameter_ranges = [[150, 250]; [0, 10]; [75, 150]; ...
                                      [150, 250]; [0, 10]; [75, 150]; ...
                                      [145, 155];  [0, 5]; [95, 105]; ...
                                          [0, 5];  [0, 5];    [0, 5]; ...
                                          [0, 5];  [0, 5];    [0, 5]; ...
                                          [0, 5];  [0, 5];    [0, 5]; ...
                                     ];
Parameters.cost_threshold_list_ind = [3.82, 3.71, 3.31, ... % x, y, z
                                      2.14, 2.67, 2.54, ...  % roll, ptch, yaw
                                     ];
Parameters.cost_threshold_list_path = 6e+21;
Parameters.cost_threshold = 0;

save("2. Init/1. Parameters/ParametersTemplate.mat", "Parameters");
