%% ========================================================================
%% Build histogram from input classes provided in testing phase.
%%
%% Parameters:
%%      centers        - Cluster centers. N*M matrix.
%%      all_des_sample - All the SURF descriptors per sample (1*n cell).
%%      THRESH         - Threshold.
%%      N              - Number of clusters.
%%
%% Returns:
%%      hists          - Contains feature histogram for all the classes.
%% ========================================================================

function hists = buildHist_test(centers, all_des_sample, THRESH, N)
    fprintf('Begin hists creation..'); fflush(stdout);

    hists = [];

    for i = 1:size(all_des_sample, 2)
        % Descriptor of each test image
        sample_des =  (all_des_sample{i});

        % kNN Search
        [IDX, D] = kNearestNeighbors(centers, double(sample_des), 1);

        % Statistics
        hist = double(zeros(1, N));

        for j = 1:size(IDX)
            if D(j) > THRESH
                continue;
            end

            hist(IDX(j)) = hist(IDX(j)) + 1;
        end

        % Normalization and summary
        hist  = hist / sum(hist);
        hists = [hists; hist];
    end

    fprintf('Done\n\n'); fflush(stdout);
end
