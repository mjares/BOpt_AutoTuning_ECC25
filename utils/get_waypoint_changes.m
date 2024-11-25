function [wayp_change_times] = get_waypoint_changes(sim_out)
% GET_WAYPOINT_CHANGES Summary of this function goes here
%   Detailed explanation goes here
    path_time = sim_out.ref_path.Time;
    path_data = sim_out.ref_path.Data;
    wayp_change_times = [];
    for ii = 1:(length(path_time) - 1)
        if ~isequal(path_data(ii, :), path_data(ii + 1, :))
            wayp_change_times = [wayp_change_times path_time(ii + 1)];
        end
    end
    if isempty(wayp_change_times)
        wayp_change_times = 0;
    end
end

