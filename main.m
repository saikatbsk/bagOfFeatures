%% ========================================================================
%% This is the main project file responsible for - (1) loading the dataset,
%% (2) extracting features, (3) creating a hists, (4) generating feature
%% histogram, and (5) classification.
%%
%% Tested with GNU Octave 4.0.2 (URL: https://www.gnu.org/software/octave/)
%% ========================================================================

%% ========================================================================
%%
%% PART 1 : Training
%%
%% ========================================================================

%% Load training and testing dataset ======================================

clear; clc;

fprintf('Loading dataset..'); fflush(stdout);

dataset_root     = '../Datasets/Caltech101/101_ObjectCategories/';
class_names      = { 'accordion' 'airplanes' 'bonsai'     'camera' 'cougar_face' ...
                     'dalmatian' 'elephant'  'gramophone' 'panda'  'stop_sign'};

image_per_class  = 30;
image_set        = imageRead(dataset_root, class_names, image_per_class);
training_set     = image_set(:, 1:24);
test_set         = image_set(:, 25:end);

fprintf('Done\n\n'); fflush(stdout);

fprintf('>>> Starting training phase..\n\n'); fflush(stdout);

%% Extract SURF features from training set ================================

% all_des        - All the SURF descriptors (m*64) or (m*128)
% all_des_sample - All the SURF descriptors per sample (1*n cell)
% class_label    - Class label for each surf descriptor (m*1)

[all_des all_des_sample class_label] = extractFeatures(training_set);

%% Creating codebook using K-mean clustering ==============================

N = 1000;    % Number of clusters

centers = createKmeanClusters(all_des, all_des_sample, N);

%% Create hists - Build histograms from training classes ==================

knnTHRESH = 0.7;

hists = buildHist_train(centers, all_des, class_label, knnTHRESH, N);

%% ========================================================================
%%
%% PART 2 : Testing
%%
%% ========================================================================

fprintf('>>> Starting testing phase..\n\n'); fflush(stdout);

%% Extract SURF features from test set ====================================

[all_des_test all_des_sample_test class_label_test] = extractFeatures(test_set);

%% Build histograms from test classes =====================================

hists_test = buildHist_test(centers, all_des_sample_test, knnTHRESH, N);

%% Classify ===============================================================

conf_mat = classify(hists, hists_test, class_names, test_set, N);

displayResults;

%// save('variables.mat');
