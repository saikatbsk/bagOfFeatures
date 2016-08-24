%% ========================================================================
%% Remove negative SURF features
%%
%% Parameters:
%%      fpts     - Positive SURF feature.
%%      idx      - Sorted array that holds the indexes to the feature
%%                 points to be removed.
%%
%% Returns:
%%      pts      - Trusted feature points.
%% ========================================================================
function pts = removeNegativeFeatures(fpts, idx)
    j = k = 1;

    for i=1:size(fpts, 2)
        if i == idx(j) && j<size(idx, 1)
            j = j+1;
        else
            pts(k).x = fpts(i).x;
            pts(k).y = fpts(i).y;
            pts(k).scale = fpts(i).scale;
            pts(k).laplacian   = fpts(i).laplacian;
            pts(k).orientation = fpts(i).orientation;
            pts(k).descriptor  = fpts(i).descriptor;

            k = k + 1;
        end
    end
end
