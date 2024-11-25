function error = abs_error_ind(sim_out, var_cost, verbose)
% ABS_ERROR_IND Calculates absolute error for individual variable 
%               responses for the ROV.
%
%   Parameters:
%   -----------
%   sim_out  : (struct) of simulations outputs.
%   var_cost : (6 x 1 boolean vector) with 1 if the performance for that
%              variable is calculated, and 0 otherwise. In order, the 
%              variables are: [x, y, z, roll, pitch, yaw]. Only one
%              position in the vector can be 1, i.e.: sum(var_cost) = 1.
%   verbose  : (boolean) 1 if the performance results are printed, 0
%              otherwise.
    
    % Default parameters
    if nargin < 3
        verbose = 0;
    end

    % Init
    pos_time = sim_out.eta_position.Time;
    pos_data = sim_out.eta_position.Data;
    rpy_time = sim_out.orientation_deg.Time;
    rpy_data = sim_out.orientation_deg.Data;
    path_time = sim_out.ref_path.Time;
    path_data = sim_out.ref_path.Data;

    % Calculate Performance
        if var_cost(1) == 1  % x
            y = pos_data(:, 1);
            y_r = path_data(:, 1);
            abs_error = abs(y - y_r);
            error = integral_trapezoidal(abs_error, path_time); 
            if verbose == 1
                fprintf('IAE    X: %0.3e.\n', error)
            end
        elseif var_cost(2) == 1  % y
            y = pos_data(:, 2);
            y_r = path_data(:, 2);
            abs_error = abs(y - y_r);
            error = integral_trapezoidal(abs_error, path_time); 
            if verbose == 1
                fprintf('IAE    Y: %0.3e.\n', error)
            end
        elseif var_cost(3) == 1  % z
            y = pos_data(:, 3);
            y_r = path_data(:, 3);
            abs_error = abs(y - y_r);
            error = integral_trapezoidal(abs_error, path_time); 
            if verbose == 1
                fprintf('IAE    Z: %0.3e.\n', error)
            end
        elseif var_cost(4) == 1  % roll
            y = rpy_data(:, 1);
            y_r = path_data(:, 4);
            abs_error = abs(y - y_r);
            error = integral_trapezoidal(abs_error, path_time); 
            if verbose == 1
                fprintf('IAE Roll: %0.3e.\n', error)
            end
        elseif var_cost(5) == 1  % pitch
            y = rpy_data(:, 2);
            y_r = path_data(:, 5);
            abs_error = abs(y - y_r);
            error = integral_trapezoidal(abs_error, path_time); 
           if verbose == 1
                fprintf('IAE   Ptch: %0.3e.\n', error)
           end
        elseif var_cost(6) == 1  % yaw
            y = rpy_data(:, 3);
            y_r = path_data(:, 6);
            abs_error = abs(y - y_r);
            error = integral_trapezoidal(abs_error, path_time); 
            if verbose == 1
                fprintf('IAE  Yaw: %0.3e.\n', error)
            end
        end
end

