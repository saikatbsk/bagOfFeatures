%% ========================================================================
%% Assign each test image to one of the possible classes by comparing its
%% histogram to histograms of all classes.
%%
%% Parameters:
%%      codebook      - Histograms from training classes
%%      codebook_test - Histograms from test classes
%%      class_names   - Names of image classes
%%      test_set      - Full path of all images
%%      N             - Number of clusters
%%
%% Returns:
%%      conf_mat      - Confusion matrix
%% ========================================================================

function conf_mat = classify(codebook, codebook_test, class_names, test_set, N)
    num_testsamples = size(codebook_test, 1);   % Number of test images
    num_class       = size(class_names, 2);     % Number of classes
    conf_mat = double(zeros(num_class, num_class));

    fprintf('Creating confusion matrix..'); fflush(stdout);

    [IDX, D] = kNearestNeighbors(codebook, codebook_test, 1);

    k = 1;

    for i = 1:num_class
        for j = 1:(num_testsamples / num_class)
            % Get original image class name
            image_path  = test_set(i, j);
            parts       = regexp(image_path, '/', 'split');
            image_class_orig = parts{1}(end - 1);

            % Get predicted image class name
            image_class_pred = class_names(IDX(k));

            conf_mat(i, IDX(k)) = conf_mat(i, IDX(k)) + 1;
            k = k + 1;
        end
    end

    % Transform to ratio confusion matrix
    for i = 1:size(conf_mat, 1)
        total_per_class = sum(conf_mat(i, :));
        conf_mat(i, :)  = conf_mat(i, :) / total_per_class;
    end

    fprintf('Done\n\n'); fflush(stdout);
end
