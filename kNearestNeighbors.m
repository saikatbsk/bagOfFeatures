%% ========================================================================
%% Find the k - nearest neighbors (kNN) within a set of points.
%% Distance metric used: Euclidean distance.
%%
%% Parameters:
%%      dataMatrix  - N*D data matrix.
%%      queryMatrix - M*D query matrix.
%%      k           - Number of nearest neighbors desired (1*1).
%%
%% Returns:
%%      neighborIds - M*1 column vector. Each row contains the index of
%%                    nearest neighbor in dataMatrix for the corresponding
%%                    row in queryMatrix.
%%      neighborDistances - M*1 column vector. Containing the distances
%%                          between each observation in queryMatrix and the
%%                          corresponding closest observation in dataMatrix
%% ========================================================================

function [neighborIds neighborDistances] = kNearestNeighbors(dataMatrix, queryMatrix, k)
    neighborIds       = zeros(size(queryMatrix, 1), k);
    neighborDistances = neighborIds;

    numDataVectors  = size(dataMatrix, 1);
    numQueryVectors = size(queryMatrix, 1);

    for i = 1:numQueryVectors
        dist = sum((repmat(queryMatrix(i, :), numDataVectors, 1) - dataMatrix).^2, 2);
        [sortval sortpos] = sort(dist, 'ascend');
        neighborIds(i, :) = sortpos(1:k);
        neighborDistances(i, :) = sqrt(sortval(1:k));
    end
end
