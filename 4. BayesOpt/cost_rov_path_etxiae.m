function cost = cost_rov_path_etxiae(ctrl_params, parameter_vector, ...
                             target_params, path_info)
% COST_ROV_PATH_IAE Evaluates the performance of a set of control 
% parameters for the ROV under a path following task.
%   Details
    
    % Preliminaries
    parameter_vector(target_params) = table2array(ctrl_params);
    
    % Run Simulation
    simln = Simulink.SimulationInput("ROV_Simulator");
    mdlWks = get_param("ROV_Simulator",'ModelWorkspace');
    assignin(mdlWks,'PID_params', parameter_vector)
    out = sim(simln);

    % Calculate Performance
    cost = etxabs_error_path(out, path_info);

end

