% This script tunes a controller (or set of controllers) using Matlab's
% bayesopt() method, given a cost function tune_objective().

clear
clc
clear('tempdir')
newTempDir = 'D:\Temp';
setenv('tmp',newTempDir);
Simulink.sdi.setAutoArchiveMode(true)
Simulink.sdi.setArchiveRunLimit(0)
% Init
verbose = 1;
save_results = 1;
resume_opt = 0;
target_parameters = true(1, 18);
iterations = 1;
save_results_filename = "Tuning_BO_Path_1ECw_eTxIAEfull" + "_STP_6e21_Imax" + string(iterations) +"_1";
acquisition_function = 'expected-improvement-plus';
% Resume
load_results_filename = "Tuning_BO_Path_1ECw_eTxIAEfull_I300_X100";
if resume_opt == 1
    save_results_filename = load_results_filename + "_X" + ...
                            string(iterations);
end
% Preliminaries
if resume_opt == 1
    load("3. Results/2. Tuning/" + load_results_filename);
    Parameters = ResultsBO.params;
    target_parameters = ResultsBO.params.tuning.target_parameter;
else
    load('ParametersTemplate.mat')
    % Reference
    Parameters.reference.reference_type = "path";
    Parameters.reference.path.reference_mask = [1; 1; 1; 1; 1; 1];
    Parameters.reference.path.waypoints = [1.5,  3,  4.5,  6,  4.5,  3,  1.5, 0;... % x
                                           1.5,  3,  1.5,  0, -1.5, -3, -1.5, 0;... % y
                                             0,  0,    0,  0,    0,  0,    0, 0;... % z
                                             0,  0,    0,  0,    0,  0,    0, 0;... % roll
                                             0,  0,    0,  0,    0,  0,    0, 0;... % ptch
                                             0,  0,    0,  0,    0,  0,    0, 0;... % yaw
                                          ];
    Parameters.reference.path.no_waypoints = 8;
    Parameters.cost_threshold = Parameters.cost_threshold_list_path;
end
% Simulate
simln = Simulink.SimulationInput("ROV_Simulator");
if resume_opt == 0
    % Control parameter vector
    cparams_names = Parameters.tuning.parameter_names;
    cparams_ranges = Parameters.tuning.parameter_ranges;
    Parameters.tuning.target_parameter = target_parameters;
    no_params = length(cparams_names);
    ctrl_params = [];  % How to preallocate optimizableVariables?
    for ii = 1:no_params
        ctrl_params_ii = optimizableVariable(cparams_names(ii), ...
            cparams_ranges(ii, :), 'Type', 'real');
        ctrl_params = [ctrl_params ctrl_params_ii]; 
    end
    % Objective function
    tune_objective = @(x)cost_rov_path_etxiae(x, Parameters.controller, ...
                                      target_parameters, ...
                                      Parameters.reference.path); 
    % Stop Criteria
    stop_function = @(x, y)stop_threshold(x, y, Parameters.cost_threshold);
end
% Bayesian Optimization Search
if resume_opt == 0
    bo_results = bayesopt(tune_objective, ctrl_params, ...
        'MaxObjectiveEvaluations', iterations, ...
        'AcquisitionFunctionName', acquisition_function, ...
        'PlotFcn', [], 'OutputFcn', stop_function);
else
    bo_results = resume(ResultsBO.bo_results, ...
    'MaxObjectiveEvaluations', iterations, ...
    'PlotFcn', []);
end
% Log
if resume_opt == 0
    ResultsBO.acquisition_function = acquisition_function;
    ResultsBO.best_control_config = Parameters.controller;
end
ResultsBO.params = Parameters;
ResultsBO.bo_results = bo_results;
ResultsBO.best_params = bo_results.XAtMinObjective;
ResultsBO.best_cost = bo_results.MinObjective;
ResultsBO.cost_evolution = bo_results.ObjectiveMinimumTrace;
ResultsBO.best_control_config(target_parameters) = table2array( ...
                                                    ResultsBO.best_params); 
ResultsBO.times.time_list = bo_results.ObjectiveEvaluationTimeTrace;
ResultsBO.times.total_time = sum( ...
    ResultsBO.bo_results.ObjectiveEvaluationTimeTrace);
ResultsBO.no_iterations = bo_results.NumObjectiveEvaluations;

if save_results == 1
    save("3. Results/2. Tuning/" + save_results_filename, "ResultsBO")
end