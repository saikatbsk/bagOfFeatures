%% ========================================================================
%% Build histogram from input classes provided in training phase.
%%
%% Parameters:
%%      centers     - Cluster centers. N*M matrix.
%%      all_des     - All the SURF descriptors (m*64).
%%      class_label - Class label for each surf descriptor (m*1).
%%      THRESH      - Threshold.
%%      N           - Number of clusters.
%%
%% Returns:
%%      codebook    - Contains feature histogram for all the classes.
%% ========================================================================

function codebook = buildHist_train(centers, all_des, class_label, THRESH, N)
    fprintf('Begin codebook creation..'); fflush(stdout);

    % Build histogram of N bins
    [IDX, D] = kNearestNeighbors(centers, double(all_des), 1);

    num_class = size(unique(class_label), 1);
    codebook  = double(zeros(num_class, N));

    for i = 1:size(IDX)
        if D(i) > THRESH
            continue;
        end

        label = class_label(i);
        codebook(label, IDX(i)) = codebook(label, IDX(i)) + 1;
    end

    % Normalize histogram
    for i = 1:num_class
        sum_bin = sum(codebook(i, :));
        codebook(i, :) = codebook(i, :) / sum_bin;
    end

    fprintf('Done\n\n'); fflush(stdout);
end
