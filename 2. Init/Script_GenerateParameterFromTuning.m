clear
clc

% Prelims
save_filename = "Parameters_IndTuning_Full_4.mat";
load_parameter_temp_filename = "ParametersTemplate.mat";
% Parameter Template
load("2. Init/1. Parameters/" + load_parameter_temp_filename);
control_params = Parameters.controller;
% Load Tuning
folder_name = "2. Tuning";
dirstruct = dir("2. Init\" + folder_name + "\");
no_files = length(dirstruct) - 2;

for ii = 1:no_files
    filename = string(dirstruct(2 + ii).name);
    load("2. Init\" + folder_name + "\" + filename)
    tgt_params = ResultsBO.params.tuning.target_parameter;
    control_params(tgt_params) = table2array(ResultsBO.best_params);
end
Parameters.controller = control_params;
save("2. Init/1. Parameters/" + save_filename, "Parameters");
