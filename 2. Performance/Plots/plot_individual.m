function plot_individual(sim_out, var_plot, plot_group, save_folder)
% PLOT_STEP Plots individual variable responses for the ROV.
%           E.g.: plot_step(out, [1 0 0 0 0 1]) plots the 'x' and 'yaw'
%           responses.
%
%   Parameters:
%   -----------
%   sim_out  : (struct) of simulations outputs.
%   var_plot : (6 x 1 boolean vector) with 1 if the variables must be 
%              plotted and 0 otherwise. In order, the variables are: 
%              [x, y, z, roll, pitch, yaw].
%              If plot_group == "3&3" var_plot is interpreted as a 2 x 1
%              vector with [position, attitude] variable plots.
%   plot_group : (string) {"individual", "3&3"} defines whether the plots
%                will be presented in individual figures or grouped into 2 
%                figures of three plots separating position variables from 
%                attitude variables.
%   save_folder : (string) Path to the folder where figures will be saved.
%                 save_folder = " " if figure won't be saved.
    
    % Default parameters
    if nargin < 3
        plot_group = "individual";
    end
    if nargin < 4
        save_folder = " ";
    end

    % Style Prelims
    xlabel_fontsize = 18;
    ylabel_fontsize = 18;
    legend_fontsize = 15;
    ax_fontsize = 25;
    title_fontsize = 20;
    meas_linewidth = 9;
    ref_linewidth = 7;
    vline_linewidth = 3;

    % ==================== Plot ======================
    pos_time = sim_out.eta_position.Time;
    pos_data = sim_out.eta_position.Data;
    rpy_time = sim_out.orientation_deg.Time;
    rpy_data = sim_out.orientation_deg.Data;
    path_time = sim_out.ref_path.Time;
    path_data = sim_out.ref_path.Data;
    waypoint_changes = get_waypoint_changes(sim_out);
    
    if plot_group == "individual"
        no_plots = sum(var_plot);
        plot_cell = {};
        % ========================  World Frame Position (XYZ)  ===========
        if var_plot(1) == 1  % x
            plot_cell_ii.xaxis_data = pos_time;
            plot_cell_ii.yaxis_data = pos_data(:, 1);
            plot_cell_ii.yaxis_ref = path_data(:, 1);
            plot_cell_ii.legend = ["X", "X_{ref}"];
            plot_cell_ii.title = 'Tracking in X [World Frame]';
            plot_cell_ii.ylabel = 'Position [m]';
            plot_cell_ii.savefig_name = "Response_X";
            plot_cell = [plot_cell; plot_cell_ii];
        end
        if var_plot(2) == 1  % y
            plot_cell_ii.xaxis_data = pos_time;
            plot_cell_ii.yaxis_data = pos_data(:, 2);
            plot_cell_ii.yaxis_ref = path_data(:, 2);
            plot_cell_ii.legend = ["Y", "Y_{ref}"];
            plot_cell_ii.title = 'Tracking in Y [World Frame]';
            plot_cell_ii.ylabel = 'Position [m]';
            plot_cell_ii.savefig_name = "Response_Y";
            plot_cell = [plot_cell; plot_cell_ii];
        end
        if var_plot(3) == 1  % z
            plot_cell_ii.xaxis_data = pos_time;
            plot_cell_ii.yaxis_data = pos_data(:, 3);
            plot_cell_ii.yaxis_ref = path_data(:, 3);
            plot_cell_ii.legend = ["Z", "Z_{ref}"];
            plot_cell_ii.title = 'Tracking in Z [World Frame]';
            plot_cell_ii.ylabel = 'Position [m]';
            plot_cell_ii.savefig_name = "Response_Z";
            plot_cell = [plot_cell; plot_cell_ii];
        end
        % ========================  Orientation (RPY)  ============================
        if var_plot(4) == 1  % roll
            plot_cell_ii.xaxis_data = rpy_time;
            plot_cell_ii.yaxis_data = rpy_data(:, 1);
            plot_cell_ii.yaxis_ref = path_data(:, 4);
            plot_cell_ii.legend = ["Roll", "Roll_{ref}"];
            plot_cell_ii.title = 'Tracking in Roll';
            plot_cell_ii.ylabel = 'Angle [deg]';
            plot_cell_ii.savefig_name = "Response_Roll";
            plot_cell = [plot_cell; plot_cell_ii];
        end
        if var_plot(5) == 1  % pitch
            plot_cell_ii.xaxis_data = rpy_time;
            plot_cell_ii.yaxis_data = rpy_data(:, 2);
            plot_cell_ii.yaxis_ref = path_data(:, 5);
            plot_cell_ii.legend = ["Pitch", "Pitch_{ref}"];
            plot_cell_ii.title = 'Tracking in Pitch';
            plot_cell_ii.ylabel = 'Angle [deg]';
            plot_cell_ii.savefig_name = "Response_Pitch";
            plot_cell = [plot_cell; plot_cell_ii];
        end
        if var_plot(6) == 1  % yaw
            plot_cell_ii.xaxis_data = rpy_time;
            plot_cell_ii.yaxis_data = rpy_data(:, 3);
            plot_cell_ii.yaxis_ref = path_data(:, 6);
            plot_cell_ii.legend = ["Yaw", "Yaw_{ref}"];
            plot_cell_ii.title = 'Tracking in Yaw';
            plot_cell_ii.ylabel = 'Angle [deg]';
            plot_cell_ii.savefig_name = "Response_Yaw";
            plot_cell = [plot_cell; plot_cell_ii];
        end
        % Plotting
        for ii = 1:no_plots
            figure('Position', [0, 0, 1024, 768])
            pltii = plot_cell{ii};
            plot(pltii.xaxis_data, pltii.yaxis_data, "LineWidth", 8)
            hold on
            plot(path_time, pltii.yaxis_ref, '--', "LineWidth", 7)
            title(pltii.title)
            legend(pltii.legend)
            xlabel('Time [s]')
            ylabel(pltii.ylabel)
            set(gca, 'FontSize', 30, 'LabelFontSizeMultiplier', 1.3, ...
                'FontName', 'Times New Roman');
            % Save figure to folder
            if save_folder ~= " "
                saveas(gca, save_folder + pltii.savefig_name + ".png");
            end
        end
    end
    
    % ======================== Grouped Plots ==============================
    if plot_group == "3&3"
        if var_plot(1) == 1
            % ========================  World Frame Position (XYZ)  =======
            figure('Position', [0, 0, 1024, 768])
            % X
            subplot(3,1,1)
            plot(pos_time, pos_data(:, 1), "LineWidth", meas_linewidth)
            hold on
            plot(path_time, path_data(:, 1), '--', "LineWidth", ref_linewidth)
            hold on
            xline(waypoint_changes, "LineWidth", vline_linewidth)
            set(gca, "Fontsize", ax_fontsize)
            title('Tracking in X [World Frame]', FontSize=title_fontsize)
            legend('X', 'X_{ref}', "Fontsize", legend_fontsize)
            xlabel('Time[s]', FontSize=xlabel_fontsize)
            ylabel('Position [m]', FontSize=ylabel_fontsize)
            % Y
            subplot(3,1,2)
            plot(pos_time, pos_data(:, 2), "LineWidth", meas_linewidth)
            hold on
            plot(path_time, path_data(:, 2), '--', "LineWidth", ref_linewidth)
            hold on
            xline(waypoint_changes, "LineWidth", vline_linewidth)
            set(gca, "Fontsize", ax_fontsize)
            title('Tracking in Y [World Frame]', FontSize=title_fontsize)
            legend('Y', 'Y_{ref}', "Fontsize", legend_fontsize)
            xlabel('Time[s]', FontSize=xlabel_fontsize)
            ylabel('Position [m]', FontSize=ylabel_fontsize)
            % Z
            subplot(3,1,3)
            plot(pos_time, pos_data(:, 3), "LineWidth", meas_linewidth)
            hold on
            plot(path_time, path_data(:, 3), '--', "LineWidth", ref_linewidth)
            hold on
            xline(waypoint_changes, "LineWidth", vline_linewidth)
            set(gca, "Fontsize", ax_fontsize)
            title('Tracking in Z [World Frame]', FontSize=title_fontsize)
            legend('Z', 'Z_{ref}', "Fontsize", legend_fontsize)
            xlabel('Time[s]', FontSize=xlabel_fontsize)
            ylabel('Position [m]', FontSize=ylabel_fontsize)
            if save_folder ~= " "
                saveas(gca, save_folder + "Position3x1.png");
            end
            % sgtitle('World Frame Position Tracking')
        end
        % ========================  Orientation (RPY)  ====================
        if var_plot(2) == 1
            figure('Position', [0, 0, 1024, 768])
            subplot(3,1,1)
            plot(rpy_time, rpy_data(:, 1), "LineWidth", meas_linewidth)
            hold on
            plot(path_time, path_data(:, 4), '--', "LineWidth", ref_linewidth)
            hold on
            xline(waypoint_changes, "LineWidth", vline_linewidth)
            set(gca, "Fontsize", ax_fontsize)
            title('Tracking in Roll', FontSize=title_fontsize)
            legend('Roll', 'Roll_{ref}', "Fontsize", legend_fontsize)
            xlabel('Time[s]', FontSize=xlabel_fontsize)
            ylabel('Angle [deg]', FontSize=ylabel_fontsize)
            % Pitch
            subplot(3,1,2)
            plot(rpy_time, rpy_data(:, 2), "LineWidth", meas_linewidth)
            hold on
            plot(path_time, path_data(:, 5), '--', "LineWidth", ref_linewidth)
            hold on
            xline(waypoint_changes, "LineWidth", vline_linewidth)
            set(gca, "Fontsize", ax_fontsize)
            title('Tracking in Pitch', FontSize=title_fontsize)
            legend('Pitch', 'Pitch_{ref}', "Fontsize", legend_fontsize)
            xlabel('Time[s]', FontSize=xlabel_fontsize)
            ylabel('Angle [deg]', FontSize=ylabel_fontsize)
            % Yaw
            subplot(3,1,3)
            plot(rpy_time, rpy_data(:, 3), "LineWidth", meas_linewidth)
            hold on
            plot(path_time, path_data(:, 6), '--', "LineWidth", ref_linewidth)
            hold on
            xline(waypoint_changes, "LineWidth", vline_linewidth)
            set(gca, "Fontsize", ax_fontsize)
            title('Tracking in Yaw', FontSize=title_fontsize)
            legend('Yaw', 'Yaw_{ref}', "Fontsize", legend_fontsize)
            xlabel('Time[s]', FontSize=xlabel_fontsize)
            ylabel('Angle [deg]', FontSize=ylabel_fontsize)
            if save_folder ~= " "
                saveas(gca, save_folder + "Attitude3x1.png");
            end
            % sgtitle('Orientation Tracking')
        end
    end
end

