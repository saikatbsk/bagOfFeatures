%% ========================================================================
%% K-means clustering.
%%
%% Parameters:
%%      all_des        - All the SURF descriptors: m*64.
%%      all_des_sample - All the SURF descriptors per sample: 1*n cell.
%%      N              - Number of clusters.
%%
%% Returns:
%%      centers        - Cluster centers. N*M matrix, N= Number of clusters
%%                       M = Descriptor dimension.
%% ========================================================================

function [centers] = createKmeanClusters(all_des, all_des_sample, N)
    nImages = size(all_des_sample, 2);  % Number of images
    [des_num des_dim] = size(all_des);  % des_num = Number of descriptors
                                        % des_dim = Dimension of descriptors

    % Initialize cluster centers
    centers = zeros(N, des_dim);
    perm = randperm(des_num);
    perm = perm(1:N);
    centers = double(all_des(perm, :));
    old_centers = centers;

    clear all_des;

    % K-means clustering
    fprintf('Begin K-mean clustering..\n'); fflush(stdout);

    nIters = 200;   % Max iterations
    thrErr = 0.01;  % Error threshold

    for n = 1:nIters
        % Center errors
        eCenter = max(max(abs(centers - old_centers)));

        % Save old centers
        old_centers = centers;

        % Temporary centers
        tmpCenters = zeros(N, des_dim);
        tot_num_per_bin = zeros(1, N);

        for i = 1:nImages
            % Get sample descriptor
            data = all_des_sample{1, i};

            id = eye(N);

            d = euclideanDistance(double(data), double(centers));

            % Assign each descriptor to nearest center
            [minvals, index] = min(d', [], 1);

            % If descriptor i is in cluster j, post(i, j) = 1, else 0
            post = id(index, :);

            tot_num_per_bin = tot_num_per_bin + sum(post, 1);

            for j = 1:N
                tmpCenters(j, :) = double(tmpCenters(j, :) + sum(data(find(post(:, j)), :), 1));
            end
        end

        fprintf('Interation %3d finished: eCenter = %f \n', n, eCenter); fflush(stdout);

        % Calculate new centres
        for j = 1:N
            if tot_num_per_bin(j) > 0
                centers(j, :) =  double(tmpCenters(j, :) / tot_num_per_bin(j));
            end
        end

        % Termination condition
        if n > 1
            % Centres is stable
            diff = max(max(abs(centers - old_centers)));
            fprintf('The center error is %f.\n', diff); fflush(stdout);

            if diff <= thrErr
                fprintf('Clustering finished.\n\n');
                break;
            end
        end
    end
end
