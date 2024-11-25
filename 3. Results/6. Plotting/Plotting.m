clear
clc

load_ind_filename = "Results_Path_Parameters_IndTuning_Full_4.mat";
load_simult_filename = "Results_Path_Tuning_BO_Path_1ECw_eTxIAEfull_I1000_GPU_STP_1e26.mat";
savefig_folder = "3. Results\6. Plotting\Images\";
plot_type = "3&3";
target_var = [1 1 1 1 1 1];
plot_tags = ["Individual", "Simultaneous"];

% Load Data
load(load_ind_filename);
out_ind = ResultsSim.out;
load(load_simult_filename);
out_sim = ResultsSim.out;
load("ParametersTemplate.mat")
ref_path = Parameters.reference.path;
% Plot Individual Var Response
% plot_individual(out_ind, target_var, plot_type, savefig_folder);
% Plot Simultaneous Var Response
% plot_individual(out_sim, target_var, plot_type, savefig_folder);
% % Plot XY Path response
plot_path_xy_multi({out_ind, out_sim}, ref_path, plot_tags, savefig_folder);
