%% ========================================================================
%% Computes Euclidean distance matrix.
%%
%% Parameters:
%%      a - (M*D) matrix.
%%      b - (N*D) matrix.
%%
%% Returns:
%%      d - Distance matrix (M*N).
%%
%% Description :
%%      Fully vectorized computation of the Euclidean distance between two
%%      vectors by,
%%              ||A-B|| = sqrt ( ||A||^2 + ||B||^2 - 2*A.B )
%% ========================================================================

function d = euclideanDistance(a, b)
    if(nargin ~= 2)
        b = a;
    end

    if(size(a, 2) ~= size(b, 2))
        fprintf('>>> Error! A and B should be of same dimensionality.\n\n'); fflush(stdout);
    end

    aa = sum(a.*a, 2);
    bb = sum(b.*b, 2);
    ab = a*b';

    d = sqrt(abs(repmat(aa, [1 size(bb, 1)]) + repmat(bb', [size(aa, 1) 1]) - 2 * ab));
end
