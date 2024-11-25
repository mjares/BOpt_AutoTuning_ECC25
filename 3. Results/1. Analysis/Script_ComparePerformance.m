clear
clc

% Flags
save_results = 0;
plotting = [1 1];  % [times, samples]
save_figs = [0 0]; % [times, samples]
% Prelims
folder_list = ["Manual", "Full", "Individual"];
no_approaches = length(folder_list);

times_cell = cell(1, no_approaches);
error_cell = cell(1, no_approaches);
errore_cell = cell(1, no_approaches);

for ii = 1:no_approaches
    % Get directory filelist
    dirstruct = dir("3. Results\1. Analysis\" + folder_list(ii) + "\");
    no_runs = length(dirstruct) - 2; % each run is a folder
    % Initialize
    times_ii = zeros(no_runs, 1);
    error_ii = zeros(no_runs, 1);
    errore_ii = zeros(no_runs, 1);
    % Full approach
    for jj = 1:no_runs
        filename = string(dirstruct(2 + jj).name);
        load("3. Results\1. Analysis\" + folder_list(ii) + "\" + filename)
        times_ii(jj) = ResultsSim.cost.ep_time;
        errore_ii(jj) = ResultsSim.cost.etx_abs_error;
        error_ii(jj) = ResultsSim.cost.abs_error;
    end
  
    times_cell{ii} = times_ii;
    error_cell{ii} = error_ii; 
    errore_cell{ii} = errore_ii;
end
% Processing results
times_cell_table = cell(1, no_approaches);
error_cell_table = cell(1, no_approaches);
errore_cell_table = cell(1, no_approaches);
for ii =  1:no_approaches
        % Table
        times_cell_table{ii} = [mean(times_cell{ii}), std(times_cell{ii})];
        error_cell_table{ii} = [mean(error_cell{ii}), std(error_cell{ii})];
        errore_cell_table{ii} = [mean(errore_cell{ii}), ...
                                  std(errore_cell{ii})];
end
% Wilcoxon Test
times_ind = times_cell{3};
times_sim = times_cell{2};
error_ind = error_cell{3};
error_sim = error_cell{2};
errore_ind = errore_cell{3};
errore_sim = errore_cell{2};
[p,h] = ranksum(times_ind, times_sim);
fprintf("Wilcoxon Test Times: %d. With p-value: %.4f\n", h, p)
[p,h] = ranksum(error_ind, error_sim);
fprintf("Wilcoxon Test IAE: %d. With p-value: %.4f\n", h, p)
[p,h] = ranksum(errore_ind, errore_sim);
fprintf("Wilcoxon Test eTxIAE: %d. With p-value: %.4f\n", h, p)
% Table Print
fprintf("Comp. Cost |    Manual    |     Indiv    |     Simult\n")
fprintf("_______________________________________________________\n")
fprintf("      Time | %.2f (%.2f)  |  %.2f (%.2f) |  %.2f (%.2f)\n", ...
        times_cell_table{1}(1), times_cell_table{1}(2), ...
        times_cell_table{3}(1), times_cell_table{3}(2), ...
        times_cell_table{2}(1), times_cell_table{2}(2))
fprintf("_______________________________________________________\n")
fprintf("      IAE | %.2f (%.2f)  |  %.2f (%.2f) |  %.2f (%.2f)\n", ...
        error_cell_table{1}(1), error_cell_table{1}(2), ...
        error_cell_table{3}(1), error_cell_table{3}(2), ...
        error_cell_table{2}(1), error_cell_table{2}(2))
fprintf("_______________________________________________________\n")
fprintf("   eTxIAE | %.2e (%.2e)  |  %.2e (%.2e) |  %.2e (%.2e)\n", ...
        errore_cell_table{1}(1), errore_cell_table{1}(2), ...
        errore_cell_table{3}(1), errore_cell_table{3}(2), ...
        errore_cell_table{2}(1), errore_cell_table{2}(2))


