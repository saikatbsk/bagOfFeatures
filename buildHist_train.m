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
%%      hists       - Contains feature histogram for all the classes.
%% ========================================================================

function hists = buildHist_train(centers, all_des, class_label, THRESH, N)
    fprintf('Begin hists creation..'); fflush(stdout);

    % Build histogram of N bins
    [IDX, D] = kNearestNeighbors(centers, double(all_des), 1);

    num_class = size(unique(class_label), 1);
    hists  = double(zeros(num_class, N));

    for i = 1:size(IDX)
        if D(i) > THRESH
            continue;
        end

        label = class_label(i);
        hists(label, IDX(i)) = hists(label, IDX(i)) + 1;
    end

    % Normalize histogram
    for i = 1:num_class
        sum_bin = sum(hists(i, :));
        hists(i, :) = hists(i, :) / sum_bin;
    end

    fprintf('Done\n\n'); fflush(stdout);
end
