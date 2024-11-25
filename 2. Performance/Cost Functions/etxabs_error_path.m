function error = etxabs_error_path(sim_out, path_info, verbose)
% ABS_ERROR_PATH Calculates absolute error for a path following task.
%
%   Parameters:
%   -----------
%   sim_out  : (struct) of simulations outputs.
%   path_info : (struct) Information about the reference path.
%   verbose  : (boolean) 1 if the performance results are printed, 0
%              otherwise.
    
    % Default parameters
    if nargin < 3
        verbose = 0;
    end

    % Init
    pos_data = sim_out.eta_position.Data;
    rpy_data = sim_out.orientation_deg.Data;
    path_time = sim_out.ref_path.Time;
    path_data = sim_out.ref_path.Data;
    ref_mask = logical(path_info.reference_mask);
    
    traj_data = [pos_data rpy_data];
   
    abs_pervar_error = abs(path_data - traj_data);
    error_pretotal = sum(abs_pervar_error(:, ref_mask), 2); % L1 norm
    error_time_mult = error_pretotal.*exp(path_time);    
    error = integral_trapezoidal(error_time_mult, path_time);

    if verbose == 1
        fprintf('eTxIAE: %0.3e.\n', error)
    end
end



