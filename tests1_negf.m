%% Random tests

% Add OpenSURF_version1c/ to Octave path
currentfile = 'tests1_negf.m';
pwd = which(currentfile);
pwd = pwd(1:(end - length(currentfile)));
addpath([pwd 'OpenSURF_version1c']);

Options.upright  = true;    % Rotation invariant
Options.tresh    = 0.0001;  % Hessian response threshold
Options.extended = true;    % Descriptor length 128

path_to_pos = {'images/airplanes/image_0024.jpg'};

path_to_neg = {'images/zz_negatives/airplanes/image_0001.jpg', ...
               'images/zz_negatives/airplanes/image_0002.jpg', ...
               'images/zz_negatives/airplanes/image_0003.jpg', ...
               'images/zz_negatives/airplanes/image_0004.jpg', ...
               'images/zz_negatives/airplanes/image_0005.jpg', ...
               'images/zz_negatives/airplanes/image_0006.jpg'};

img_pos = imread(char(path_to_pos(1)));
pts_pos = OpenSurf(img_pos, Options);
PaintSURF(img_pos, pts_pos);

for itr = 1:size(path_to_neg, 2)
    img_neg = imread(char(path_to_neg(itr)));
    pts_neg = OpenSurf(img_neg, Options);

    matches = [matches; kNearestNeighbors([pts_pos.descriptor]', [pts_neg.descriptor]', 1)];
end

matches = unique(matches);
if size(matches, 1) > 100
    matches = matches(1:100);
end

pts_fin = removeNegativeFeatures(pts_pos, matches);
PaintSURF(img_pos, pts_fin);
