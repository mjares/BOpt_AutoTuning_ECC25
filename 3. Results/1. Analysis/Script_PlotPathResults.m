% This script plots a path following response given a control configu, 
% as well as the cost evolution for the
% BO tuning task. It can optionally save the results as images.

sim_response = 1;
if sim_response == 1 % If 0, keep previous workspace
    clear
    clc
    sim_response = 1;  % Reassign since cleared
end

% Flags
save_results = 1;
verbose = 1;
plotting = [1 1 0];  % [3&3 XY_path cost_evol]
save_figs = [1 0 0]; % [3&3 XY_path cost_evol]

% Preliminaries
parameter_filename = "Parameters_IndTuning_Full_4";
control_source = "tuning"; % Tuning File, Parameters File, or Manual Input
load_results_filename = "Tuning_BO_Path_1ECw_eTxIAEfull_I1000_GPU_STP_1e26";
% load_results_filename = "Tuning_BO_Path_1ECw_IAEfull_I100";
cost_function = "Exponential Time IAE";

% Plot & Save
plot_type = "3&3";
target_var = [1 1 1 1 1 1];
if control_source == "tuning"
    save_filename = load_results_filename;
    parameter_filename = "ParametersTemplate";
else
    save_filename = parameter_filename;
end
savefig_folder = "3. Results/4. Images/";
save_results_filename = "Results_Path_" + save_filename;

% Load
load(parameter_filename)
% Reference
Parameters.reference.reference_type = 'path';
Parameters.reference.path.reference_mask = [1; 1; 1; 1; 1; 1];
Parameters.reference.path.waypoints = [1.5,  3,  4.5,  6,  4.5,  3,  1.5, 0;... % x
                                       1.5,  3,  1.5,  0, -1.5, -3, -1.5, 0;... % y
                                         0,  0,    0,  0,    0,  0,    0, 0;... % z
                                         0,  0,    0,  0,    0,  0,    0, 0;... % roll
                                         0,  0,    0,  0,    0,  0,    0, 0;... % ptch
                                         0,  0,    0,  0,    0,  0,    0, 0;... % yaw
                                      ];
Parameters.reference.path.no_waypoints = 8;
% Control
if control_source == "manual"
    Parameters.controller(target_parameters) = [150, 0, 100];
    PID_params = Parameters.controller;  % Insert params here
elseif control_source == "tuning"
    load("3. Results/2. Tuning/" + load_results_filename)
    % Parameters = ResultsBO.params;
    PID_params = ResultsBO.best_control_config;
elseif control_source == "parameters"
    PID_params = Parameters.controller;
end

% Simulate
if sim_response == 1
    simln = Simulink.SimulationInput("ROV_Simulator");
    mdlWks = get_param("ROV_Simulator",'ModelWorkspace');
    assignin(mdlWks,'PID_params', PID_params)
    out = sim(simln);
end
% Plot Individual Var Response
if plotting(1) == 1
    if save_figs(1) == 1
        plot_individual(out, target_var, plot_type, savefig_folder);
    else
        plot_individual(out, target_var, plot_type);
    end
end
% Plot XY Path response
if plotting(2) == 1
    if save_figs(2) == 1
        plot_path_xy(out, Parameters.reference.path, savefig_folder);
    else
        plot_path_xy(out, Parameters.reference.path);
    end
end
% Plotting BO cost evolution
if plotting(3) == 1
    if save_figs(3) == 1
        plot_cost_evolution(ResultsBO.cost_evolution, cost_function, ...
            savefig_folder, "Cost");
    else
        plot_cost_evolution(ResultsBO.cost_evolution, cost_function);
    end
end

% Performance
cost_iae = abs_error_path(out, Parameters.reference.path, verbose);
cost_etxiae = etxabs_error_path(out, Parameters.reference.path, verbose);

% Saving
ResultsSim.out = out;
ResultsSim.params = Parameters;
ResultsSim.cost.abs_error = cost_iae; 
ResultsSim.cost.etx_abs_error = cost_etxiae;
ResultsSim.cost.cost_function = cost_function;
ResultsSim.cost.ep_time = out.ref_path.Time(end);
if control_source == "tuning"
    ResultsSim.opt_iterations = ResultsBO.no_iterations;
    ResultsSim.opt_time = ResultsBO.times.total_time;
end
if save_results == 1
    save("3. Results/3. Runs/" + save_results_filename, "ResultsSim")
end
% ep_time = [47.0476, 80.8461, 67.9663]
% cost = [3.5776e+20, 2.1307e+35, 7.768e+29]