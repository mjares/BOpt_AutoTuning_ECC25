% This script loads a step response tuning results file and plots the step
% response for the tuned controller, as well as the cost evolution for the
% BO tuning task. It can optionally save the results as images.

sim_response = 1;
if sim_response == 1
    clear
    clc
    sim_response = 1;
end

% Flags
save_results = 0;
verbose = 1;
plotting = [1 0];  % [ step, cost_evol]
save_figs = [0 0]; % [response, cost]

% Preliminaries
var = "Z";
[target_parameters, target_var, step_signal] = get_target_vector(var);

control_source = "tuning"; % Tuning File, Parameters File, or Manual Input
load_results_filename = "Tuning_BO_Step_Z_IAE_STP_Imax100_2";
cost_function = "Integral Absolute Error";

% Plot & Save
parameter_filename = "ParametersTemplate";
savefig_folder = "3. Results/4. Images/Manual_Tuning/";
% save_results_filename = "Results_Step_" + var + "_BOInd"+ var + "_200c_IAE";
if control_source == "tuning"
    save_filename = load_results_filename;
else
    save_filename = "Placeholder";
end
save_results_filename = "Results_Step_" + save_filename;

% Load
load(parameter_filename)
% Reference
Parameters.reference.step_signal = step_signal;
Parameters.reference.reference_type = 'step';
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
% Plot Step Response
if plotting(1) == 1
    if save_figs(1) == 1
        plot_individual(out, target_var, "individual", savefig_folder);
    else
        plot_individual(out, target_var);
    end
end
% Plotting BO cost evolution
if plotting(2) == 1
    if save_figs(2) == 1
        plot_cost_evolution(ResultsBO.cost_evolution, cost_function, ...
            savefig_folder, "Cost_" + var);
    else
        plot_cost_evolution(ResultsBO.cost_evolution, cost_function);
    end
end

% Performance
cost = abs_error_ind(out, target_var, verbose);

% Saving
ResultsSim.out = 0;  % Not saving simout to save space
% ResultsSim.out = out;
ResultsSim.params = Parameters;
ResultsSim.cost.abs_error = cost; 
ResultsSim.cost.cost_function = cost_function;
if control_source == "tuning"
    ResultsSim.opt_iterations = ResultsBO.no_iterations;
    ResultsSim.opt_time = ResultsBO.times.total_time;
end
if save_results == 1
    save("3. Results/3. Runs/" + save_results_filename, "ResultsSim")
end