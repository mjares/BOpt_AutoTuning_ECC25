function plot_cost_evolution(cost, objective_name, save_folder, save_file)
% PLOT_COST_EVOLUTION Plots optimization best cost evolution over
% iterations.
%
%   Parameters:
%   -----------
%   cost  : (double vector) Cost over iterations.
%   objective_name : (string) String with the cost function name for the 
%                    ylabel of the plot.
%   save_folder : (string) Path to the folder where figures will be saved.
%                 save_folder = " " if figure won't be saved.
%   save_file : 
    
    % Default parameters
    if nargin < 3
        save_folder = " ";
        save_file = "Cost";
    end
    if nargin < 4
        save_file = "Cost";
    end
    
    fig = figure;
    fig.Position = [0, 0, 1024, 768];
    plot(cost, '-d', "LineWidth", 7, "MarkerFaceColor", 'r', ...
        "MarkerEdgeColor",'r', "MarkerSize", 3)
    xlabel('Iteration');
    ylabel(objective_name);
    set(gca, 'FontSize', 30, 'LabelFontSizeMultiplier', 1.3, ...
        'FontName', 'Times New Roman');
    % Save figure to file
    if save_folder ~= " " 
        saveas(gca, save_folder + save_file + ".png")
    end
    % axis square