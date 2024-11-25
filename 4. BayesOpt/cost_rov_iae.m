function cost = cost_rov_iae(ctrl_params, parameter_vector, ...
                             target_params, target_var)
% COST_ROV Evaluates the performance of a set of control parameters for the
% ROV
%   Details
    
    % Preliminaries
    parameter_vector(target_params) = table2array(ctrl_params);
    
    % Run Simulation
    simln = Simulink.SimulationInput("ROV_Simulator");
    mdlWks = get_param("ROV_Simulator",'ModelWorkspace');
    assignin(mdlWks,'PID_params', parameter_vector)
    out = sim(simln);

    % Calculate Performance
    cost = abs_error_ind(out, target_var);

end

