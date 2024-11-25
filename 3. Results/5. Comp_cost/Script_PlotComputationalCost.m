clear
clc

% Flags
save_results = 0;
plotting = [1 1];  % [times, samples]
save_figs = [1 1]; % [times, samples]
% Prelims
folder_list = ["Full", "Individual"];
approach_tag = ["Simultaneous", "Individual"];
no_stages_per_approach = [1, 6]; % 1 stage for the simult and 6 for the ind
no_approaches = length(folder_list);

times_cell = cell(1, no_approaches);
samples_cell = cell(1, no_approaches);

for ii = 1:no_approaches
    % Get directory filelist
    dirstruct = dir("3. Results\5. Comp_cost\" + folder_list(ii) + "\");
    no_runs = length(dirstruct) - 2; % each run is a folder
    % Initialize
    times_ii = zeros(no_runs, no_stages_per_approach(ii));
    samples_ii = zeros(no_runs, no_stages_per_approach(ii));
    % Full approach
    if folder_list(ii) == "Full"
        for jj = 1:no_runs
            filename = string(dirstruct(2 + jj).name);
            load("3. Results\5. Comp_cost\" + folder_list(ii) + "\" + filename)
            times_ii(jj) = ResultsBO.times.total_time;
            samples_ii(jj) = ResultsBO.no_iterations;
        end
    end
    % Individual approach
    if folder_list(ii) == "Individual"
        for jj = 1:no_runs
            % Get directory filelist for run folder
            dirstruct_run = dir("3. Results\5. Comp_cost\" + ...
                                folder_list(ii) + "\" + ...
                                dirstruct(2+jj).name + "\");
            no_stages =  length(dirstruct_run) - 2;
            for kk = 1:no_stages
                filename = string(dirstruct_run(2 + kk).name);
                load("3. Results\5. Comp_cost\" + folder_list(ii) + "\" + ...
                     dirstruct(2+jj).name + "\" + filename)
                times_ii(jj, kk) = ResultsBO.times.total_time;
                samples_ii(jj, kk) = ResultsBO.no_iterations;
            end   
        end
    end
    times_cell{ii} = times_ii;
    samples_cell{ii} = samples_ii;    
end
% Processing results
times_cell_plot = cell(1, no_approaches);
samples_cell_plot = cell(1, no_approaches);
times_cell_table = cell(1, no_approaches);
samples_cell_table = cell(1, no_approaches);
for ii =  1:no_approaches
    if folder_list(ii) == "Full"
        times_cell{ii} = times_cell{ii}/3600; % Changing to hours
        % Plot
        times_cell_plot{ii} = mean(times_cell{ii});
        samples_cell_plot{ii} = mean(samples_cell{ii});
        % Table
        times_cell_table{ii} = [mean(times_cell{ii}), std(times_cell{ii})];
        samples_cell_table{ii} = [mean(samples_cell{ii}), ...
                                  std(samples_cell{ii})];
    elseif folder_list(ii) == "Individual"
        times_cell{ii} = times_cell{ii}/3600; % Changing to hours
        % Plot
        times_cell_plot{ii} = mean(times_cell{ii});
        samples_cell_plot{ii} = mean(samples_cell{ii});
        % Table
        total_time = sum(times_cell{ii}, 2);
        times_cell_table{ii} = [mean(total_time), std(total_time)];
        total_samples = sum(samples_cell{ii}, 2);
        samples_cell_table{ii} = [mean(total_samples), std(total_samples)];
    end
end

% Wilcoxon Test
[p,h] = ranksum([total_samples, samples_cell{1});
fprintf("Wilcoxon Test Samples: %d. With p-value: %.4f\n", h, p)
[p,h] = ranksum(total_time, times_cell{1});
fprintf("Wilcoxon Test Time: %d. With p-value: %.4f\n", h, p)
% Table Print
fprintf("Comp. Cost |     Indiv    |     Simult\n")
fprintf("____________________________________________\n")
fprintf("      Time | %.2f (%.2f)  |  %.2f (%.2f) \n", ...
        times_cell_table{2}(1), times_cell_table{2}(2), ...
        times_cell_table{1}(1), times_cell_table{1}(2))
fprintf("____________________________________________\n")
fprintf("   Samples | %.2f (%.2f)  |  %.2f (%.2f) \n", ...
        samples_cell_table{2}(1), samples_cell_table{2}(2), ...
        samples_cell_table{1}(1), samples_cell_table{1}(2))
% Bar Plot
figure('Position', [0, 0, 1024, 768])
for ii = 1:no_approaches
    X = categorical(approach_tag(ii));
    bar(X, times_cell_plot{ii}, "stacked")
    hold on
end
xlabel("Tuning Approach")
ylabel("Time [s]")
set(gca, 'FontSize', 20, 'LabelFontSizeMultiplier', 1.3, ...
    'FontName', 'Times New Roman');

% Sample Complexity
figure('Position', [0, 0, 1024, 768])
for ii = 1:no_approaches
    X = categorical(approach_tag(ii));
    bar(X, samples_cell_plot{ii}, "stacked")
    hold on
end
xlabel("Tuning Approach")
ylabel("Iterations")
set(gca, 'FontSize', 20, 'LabelFontSizeMultiplier', 1.3, ...
    'FontName', 'Times New Roman');

