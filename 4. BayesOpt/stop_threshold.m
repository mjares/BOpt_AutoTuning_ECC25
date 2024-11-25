function stop = stop_threshold(results, state, threshold)
% STOP_THRESHOLD Checks if the current optimum is below a predefined
% threshold and, if so, issues a stop search command to bayesopt.
%
%   Parameters:
%   -----------
%   results : (bayesopt results) Overall information on the state of the
%               optimization task.
%   state : (string) ['initial', 'iteration, 'done'] state of the
%           optimization task.
%   threshold : (double) cost function threshold.
%
%   Return:
%   -------
%   stop : (bool) if true, stop bayesopt.

    stop = false;
    if results.MinObjective < threshold
        stop = true;
    end
end

