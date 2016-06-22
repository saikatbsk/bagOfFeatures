%% ========================================================================
%% Test single JPG images to see how the system performs.
%% ========================================================================

% Either run main or load variables.mat

%// load('variables.mat');

% Get the test image from user and test

op   = '';

while ~strcmp(op, 'N')
    prompt = '[category/filename] of test image? '; fflush(stdout);
    %// prompt = 'Test image? '; fflush(stdout);
    str    = input(prompt, 's');

    filename = fullfile(dataset_root, str);
    %// filename = str;

    if exist(filename, 'file') == 2
        img = imread(filename);

        % Test against the training set
        test_im(1, 1) = { filename };

        [all_des_test_im all_des_sample_test_im class_label_test_im] = extractFeatures(test_im);
        codebook_test_im = buildHist_test(centers, all_des_sample_test_im, knnTHRESH, N);

        [IDX, D]   = kNearestNeighbors(codebook, codebook_test_im, 1);
        prediction = class_names(IDX(1));

        fprintf('PREDICTION: %s\n\n', char(prediction)); fflush(stdout);

        mytext = strcat('PREDICTION: ', prediction);

        imshow(img);
        title(mytext, 'fontsize', 16, 'color', 'red');
    else
        fprintf('>>> File does not exist!\n\n'); fflush(stdout);
    end

    prompt = 'Try again? [y/n] ';
    op     = input(prompt, 's');

    if strcmp(op, 'n')
        op = 'N';
    end
end
