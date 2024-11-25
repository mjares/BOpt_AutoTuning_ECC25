function plot_path_xy_multi(sim_out, path_info, plot_tags, save_folder)
% PLOT_PATH_XY Plots 2D path trajectory tracking response.
%
%   Parameters:
%   -----------
%   sim_out  : (struct) of simulations outputs.
%   path_info : (struct) Information about the reference path.
%   save_folder : (string) Path to the folder where figures will be saved.
%                 save_folder = " " if figure won't be saved.
    
    % Default parameters
    if nargin < 4
        save_folder = " ";
    end

    % Allocate Data
    no_plots = length(plot_tags);
    legend_str = [plot_tags, "Reference"];
    title_str = 'XY Square Path Tracking';
    xlabel_str = 'X Position [m]';
    ylabel_str = 'Y Position [m]';
    color = ["#0072BD", "#77AC30"];

    figure('Position', [0, 0, 1024, 768])
    for ii = 1:no_plots
        pos_data = sim_out{ii}.eta_position.Data;
        path_data = sim_out{ii}.ref_path.Data;
    
        xaxis_data = pos_data(:, 1);
        yaxis_data = pos_data(:, 2);
        xaxis_ref = path_data(:, 1);
        yaxis_ref = path_data(:, 2);
        
        % Adding initial conditions to the reference vector so the reference
        % plot includes the section from the initial conditions to the first
        % waypoint.
        xaxis_data = [xaxis_data(1); xaxis_data];
        yaxis_data = [yaxis_data(1); yaxis_data];
        xaxis_ref = [xaxis_data(1); xaxis_ref];
        yaxis_ref = [yaxis_data(1); yaxis_ref];
    
        % Plotting 
        plot(xaxis_data, yaxis_data, "LineWidth", 5, Color=color(ii))
        hold on

    end
    plot(xaxis_ref, yaxis_ref,'--x', 'MarkerSize', 13, "LineWidth", 5, "Color", "#D95319")

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



