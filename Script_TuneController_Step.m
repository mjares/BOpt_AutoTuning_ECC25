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
var = "Z";
[target_parameters, target_var] = get_target_vector(var);
verbose = 1;
save_results = 1;
iterations = 100;
results_filename = "Tuning_BO_Step_" + var + "_IAE_STP_Imax" + string(iterations) + "_1";
acquisition_function = 'expected-improvement-plus';
% Preliminaries
load('ParametersTemplate_AttBO200c.mat')
% Reference
Parameters.reference.reference_type = "step";
Parameters.reference.step_signal = [0, 0, 3, 0, 0, 0];
simln = Simulink.SimulationInput("ROV_Simulator");
% Control parameter vector
cparams_names = Parameters.tuning.parameter_names(target_parameters);
cparams_ranges = Parameters.tuning.parameter_ranges(target_parameters, :);
Parameters.tuning.target_parameter = target_parameters;
Parameters.cost_threshold = 3.303;
no_params = length(cparams_names);
ctrl_params = [];  % How to preallocate optimizableVariables?
for ii = 1:no_params
    ctrl_params_ii = optimizableVariable(cparams_names(ii), ...
        cparams_ranges(ii, :), 'Type', 'real');
    ctrl_params = [ctrl_params ctrl_params_ii]; 
end

% Objective function
tune_objective = @(x)cost_rov_iae(x, Parameters.controller, ...
                                  target_parameters, target_var); 
% Stop Criteria
stop_function = @(x, y)stop_threshold(x, y, Parameters.cost_threshold);
% Bayesian Optimization Search
bo_results = bayesopt(tune_objective, ctrl_params, ...
    'MaxObjectiveEvaluations', iterations, ...
    'AcquisitionFunctionName', acquisition_function, ...
    'PlotFcn', [], 'OutputFcn', stop_function);
% Log
ResultsBO.params = Parameters;
ResultsBO.bo_results = bo_results;
ResultsBO.best_params = bo_results.XAtMinObjective;
ResultsBO.best_cost = bo_results.MinObjective;
ResultsBO.cost_evolution = bo_results.ObjectiveMinimumTrace;
ResultsBO.acquisition_function = acquisition_function;
ResultsBO.best_control_config = Parameters.controller;
ResultsBO.best_control_config(target_parameters) = table2array( ...
                                                    ResultsBO.best_params);
ResultsBO.times.time_list = bo_results.ObjectiveEvaluationTimeTrace;
ResultsBO.times.total_time = sum( ...
    ResultsBO.bo_results.ObjectiveEvaluationTimeTrace);
ResultsBO.no_iterations = bo_results.NumObjectiveEvaluations;

if save_results == 1
    save("3. Results/2. Tuning/" + results_filename, "ResultsBO")
end