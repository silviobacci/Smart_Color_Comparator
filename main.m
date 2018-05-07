%% Add paths of subfolders to MATLAB paths
addpath(genpath('./clustering'));
addpath(genpath('./conversion_functions'));
addpath(genpath('./gui_functions'));
addpath(genpath('./nn_functions'));
addpath(genpath('./plot_functions'));
addpath(genpath('./utility_functions'));
addpath(genpath('./workspace'));

%% Clear workspace and command window

clc;
clear;

%% Load created workspace

load CI_dataset_new.mat;
load CI_copy_evaluation_2.mat;
load CI_fuzzy_evaluation.mat;
load CI_best_nn.mat