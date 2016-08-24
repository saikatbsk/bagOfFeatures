%% ========================================================================
%% Extract SURF features from images.
%% NOTE: Requires OpenSURF_version1c/ to be in current path.
%%
%% Parameters:
%%      image_set      - Holds paths to images. M*N cell array, M = Number of
%%                       image categories, N = Samples per category.
%%      neg_image_set  - Holds paths to negative images. Dimension same as
%%                       image_set.
%%
%% Returns:
%%      all_des        - All the SURF descriptors: m*64.
%%      all_des_sample - All the SURF descriptors per sample: 1*n cell.
%%      class_label    - Class label for each surf descriptor: m*1.
%% ========================================================================

function [all_des all_des_sample class_label] = extractFeatures(image_set, neg_image_set)
    all_des = [];
    all_des_sample = {};
    class_label = [];

    Options.upright  = true;    % Rotation invariant
    Options.tresh    = 0.0001;  % Hessian response threshold
    Options.extended = true;    % Descriptor length 128

    K = 128;                    % Must be same with SURF dimension

    % Add OpenSURF_version1c/ to Octave path
    currentfile = 'extractFeatures.m';
    pwd = which(currentfile);
    pwd = pwd(1:(end - length(currentfile)));
    addpath([pwd 'OpenSURF_version1c']);

    k = 0;

    fprintf('Extracting SURF descriptors from input samples..'); fflush(stdout);

    if nargin == 2
        for i = 1:size(neg_image_set, 1)
            pts_neg = {};
            matches = [];

            for j = 1:size(neg_image_set, 2)
                str = char(neg_image_set(i, j));
                img = imread(str);
                pts = OpenSurf(img, Options);

                pts_neg{j} = pts;

                disp(j); fflush(stdout);
            end
        end
    end

    for i = 1:size(image_set, 1)
        k = k + 1;

        for j = 1:size(image_set, 2)
            str = char(image_set(i, j));
            img = imread(str);
            pts = OpenSurf(img, Options);

            if nargin == 2
                for itr = 1:size(neg_image_set, 2)
                    matches = [matches; kNearestNeighbors([pts.descriptor]', [pts_neg{itr}.descriptor]', 1)];
                end

                matches = unique(matches);
                if size(matches, 1) > 80
                    matches = matches(1:80);
                end

                if size(pts, 2) > 160
                    pts_fin = removeNegativeFeatures(pts, matches);
                end
            end

            % Landmark descriptors
            if nargin == 2
                D = (reshape([pts_fin.descriptor], K, []))';
            else
                D = (reshape([pts.descriptor], K, []))';
            end

            all_des = cat(1, all_des, D);                   % same as [all_des; D]
            all_des_sample = cat(2, all_des_sample, D);     % same as [all_des_sample, D]

            tmp = ones(size(D, 1), 1) * k;
            class_label = cat(1, class_label, tmp);         % same as [class_label; tmp]

            disp(str); fflush(stdout);
        end
    end

    fprintf('Done\n\n'); fflush(stdout);
end
