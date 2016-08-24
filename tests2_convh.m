%% Random tests

% Add OpenSURF_version1c/ to Octave path
currentfile = 'tests2_convh.m';
pwd = which(currentfile);
pwd = pwd(1:(end - length(currentfile)));
addpath([pwd 'OpenSURF_version1c']);

Options.upright  = true;    % Rotation invariant
Options.tresh    = 0.0001;  % Hessian response threshold
Options.extended = true;    % Descriptor length 128

path_to_img = {'images/airplanes/image_0024.jpg'};

img = imread(char(path_to_img(1)));
pts = OpenSurf(img, Options);

X = [pts.x]';
Y = [pts.y]';
K = convhull(X, Y);

x = X(K);
y = Y(K);
[m n c] = size(img);
bw = poly2mask(x', y', m, n);

img_masked = bsxfun(@times, img, cast(bw, 'uint8'));

imshow(img_masked);
PaintSURF(img, pts);
