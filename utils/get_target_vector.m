function [target_parameter, target_var, step_signal] = get_target_vector( ...
                                                       var, params)
% GET_TARGET_VECTOR Given a target control variable(s) to tune and a 
%   desired set of parameters for the variable's controller. This function
%   outputs the properly formatted target_parameter and target_var vectors.
%   The main purpose of this function is to improve legibility.
% 
%   Parameters:
%   -----------
%       var : (string vector) with the name of the target variables to
%             tune.
%       params : (1 x 3 double) representing [kp, ki, kd]. 1 if the
%                parameter will be tuned, 0 otherwise.
%   Return:
%   -------
%       target_parameters : (1 x 3*no_vars) logical vector with with true 
%                           for the target parameters 
%       target_var : (1 x no_vars) vector with 1 if the variable is
%                    targeted.
%       step_signal : (1 x no_vars) default step signal magnitude for the 
%                     step_reference, only relevant if an individual 
%                     variable is selected.
% Note: We assume only 6 target variables with 3 parameters each.

    % Default Inputs
    if nargin < 2
        params = [1 1 1];
    end
    
    % Initialize
    no_vars = 6;
    no_params = 3;
    target_var = zeros(1, no_vars);
    step_signal = zeros(no_vars, 1);

    % If all variables
    if any(var == "Full")
        target_var = ones(1, no_vars);
    end
    
    % If position variables
    if any(var == "Position")
        target_var(1:3) = [1 1 1];
    elseif any(var == "X")
        target_var(1) = 1;
        step_signal(1) = 3;
    elseif any(var == "Y")
        target_var(2) = 1;
        step_signal(2) = 3;
    elseif any(var == "Z")
        target_var(3) = 1;
        step_signal(3) = 3;
    end

    % If position variables
    if any(var == "Attitude")
        target_var(4:6) = [1 1 1];
    elseif any(var == "Roll")
        target_var(4) = 1;
        step_signal(4) = 5;
    elseif any(var == "Ptch")
        target_var(5) = 1;
        step_signal(5) = 5;
    elseif any(var == "Yaw")
        target_var(6) = 1;
        step_signal(6) = 5;
    end
    
    % Target Params
    target_parameter = false(1, no_vars*no_params);
    if ~any(target_var == 1)  % If no variable was selected
        fprintf("ERROR: Target variables are not correct!")
        return
    end

    for ii = 1:no_vars
        if target_var(ii) == 1
            target_parameter((ii - 1)*no_params + 1:ii*no_params) = params;
        end
    end
