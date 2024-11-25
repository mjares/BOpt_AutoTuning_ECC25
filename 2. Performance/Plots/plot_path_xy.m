function plot_path_xy(sim_out, path_info, save_folder)
% PLOT_PATH_XY Plots 2D path trajectory tracking response.
%
%   Parameters:
%   -----------
%   sim_out  : (struct) of simulations outputs.
%   path_info : (struct) Information about the reference path.
%   save_folder : (string) Path to the folder where figures will be saved.
%                 save_folder = " " if figure won't be saved.
    
    % Default parameters
    if nargin < 3
        save_folder = " ";
    end

    % Allocate Data
    pos_data = sim_out.eta_position.Data;
    path_data = sim_out.ref_path.Data;
    no_waypoints = path_info.no_waypoints;
    waypoint_thresh = path_info.waypoint_thresh;
    last_waypoint_thresh = path_info.last_waypoint_thresh;
    x_wayp = path_info.waypoints(1, :);
    y_wayp = path_info.waypoints(2, :);

    xaxis_data = pos_data(:, 1);
    yaxis_data = pos_data(:, 2);
    xaxis_ref = path_data(:, 1);
    yaxis_ref = path_data(:, 2);
    legend_str = ["Trajectory", "Reference"];
    title_str = 'XY Square Path Tracking';
    xlabel_str = 'X Position [m]';
    ylabel_str = 'Y Position [m]';
    
    % Adding initial conditions to the reference vector so the reference
    % plot includes the section from the initial conditions to the first
    % waypoint.
    xaxis_data = [xaxis_data(1); xaxis_data];
    yaxis_data = [yaxis_data(1); yaxis_data];
    xaxis_ref = [xaxis_data(1); xaxis_ref];
    yaxis_ref = [yaxis_data(1); yaxis_ref];

    % Plotting 
    figure('Position', [0, 0, 1024, 768])
    plot(xaxis_data, yaxis_data, "LineWidth", 5)
    hold on
    plot(xaxis_ref, yaxis_ref,'--xr', 'MarkerSize', 10, "LineWidth", 5)
    % hold on
    % for ii = 1:no_waypoints
    %     if ii ~= no_waypoints
    %         [x_circle, y_circle] = circle(x_wayp(ii), y_wayp(ii), waypoint_thresh);
    %         plot(x_circle, y_circle, 'g', "LineWidth", 3)
    %         hold on
    %     else
    %         [x_circle, y_circle] = circle(x_wayp(ii), y_wayp(ii), last_waypoint_thresh);
    %         plot(x_circle, y_circle, 'g', "LineWidth", 3)
    %     end
    % end
    title(title_str)
    legend(legend_str)
    xlabel(xlabel_str)
    ylabel(ylabel_str)
    set(gca, 'FontSize', 30, 'LabelFontSizeMultiplier', 1.3, ...
        'FontName', 'Times New Roman');
    
    % Save figure to folder
    if save_folder ~= " "
        saveas(gca, save_folder + "XY_Path" + ".png");
    end

end



