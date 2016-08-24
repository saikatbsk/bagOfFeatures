% Add OpenSURF_version1c/ to Octave path
currentfile = 'tests3_matching.m';
pwd = which(currentfile);
pwd = pwd(1:(end - length(currentfile)));
addpath([pwd 'OpenSURF_version1c']);

Options.upright  = true;    % Rotation invariant
Options.tresh    = 0.0001;  % Hessian response threshold
Options.extended = true;    % Descriptor length 128

I1 = imread('images/gramophone/image_0031.jpg');
I2 = imread('images/crab/image_0026.jpg');

pts1 = OpenSurf(I1, Options);
pts2 = OpenSurf(I2, Options);

matches = [];

path_to_neg1 = {'images/zz_negatives/gramophone/image_0001.jpg', ...
                'images/zz_negatives/gramophone/image_0002.jpg', ...
                'images/zz_negatives/gramophone/image_0003.jpg', ...
                'images/zz_negatives/gramophone/image_0004.jpg', ...
                'images/zz_negatives/gramophone/image_0005.jpg', ...
                'images/zz_negatives/gramophone/image_0006.jpg'};

for itr = 1:size(path_to_neg1, 2)
    img_neg1 = imread(char(path_to_neg1(itr)));
    pts_neg1 = OpenSurf(img_neg1, Options);

    matches = [matches; kNearestNeighbors([pts1.descriptor]', [pts_neg1.descriptor]', 1)];
end

matches = unique(matches);
if size(matches, 1) > 100
    matches = matches(1:100);
end

pts1_fin = removeNegativeFeatures(pts1, matches);

matches = [];

path_to_neg2 = {'images/zz_negatives/crab/image_0001.jpg', ...
                'images/zz_negatives/crab/image_0002.jpg', ...
                'images/zz_negatives/crab/image_0003.jpg', ...
                'images/zz_negatives/crab/image_0004.jpg', ...
                'images/zz_negatives/crab/image_0005.jpg', ...
                'images/zz_negatives/crab/image_0006.jpg'};

for itr = 1:size(path_to_neg2, 2)
    img_neg2 = imread(char(path_to_neg2(itr)));
    pts_neg2 = OpenSurf(img_neg2, Options);

    matches = [matches; kNearestNeighbors([pts2.descriptor]', [pts_neg2.descriptor]', 1)];
end

matches = unique(matches);
if size(matches, 1) > 100
    matches = matches(1:100);
end

pts2_fin = removeNegativeFeatures(pts2, matches);

% Put the landmark descriptors in a matrix
D1 = reshape([pts1_fin.descriptor],128,[]);
D2 = reshape([pts2_fin.descriptor],128,[]);

% Find the best matches
err=zeros(1,length(pts1_fin));
cor1=1:length(pts1_fin);
cor2=zeros(1,length(pts1_fin));

for i=1:length(pts1_fin),
  distance=sum((D2-repmat(D1(:,i),[1 length(pts2_fin)])).^2,1);
  [err(i),cor2(i)]=min(distance);
end

% Sort matches on vector distance
[err, ind]=sort(err);
cor1=cor1(ind);
cor2=cor2(ind);

% Show both images
I = zeros([max(size(I1,1), size(I2,1)) size(I1,1)+size(I2,2) size(I1,3)]);
I(1:size(I1,1),1:size(I1,2),:) = I1;
I(1:size(I2,1),size(I1,2)+1:size(I1,2)+size(I2,2),:)=I2;
figure, imshow(I/255); hold on;

% Show the best matches
for i=1:size(cor1, 2)
  c=rand(1,3);
  plot([pts1_fin(cor1(i)).x pts2_fin(cor2(i)).x+size(I1,2)],[pts1_fin(cor1(i)).y pts2_fin(cor2(i)).y],'-','Color',c);
  plot([pts1_fin(cor1(i)).x pts2_fin(cor2(i)).x+size(I1,2)],[pts1_fin(cor1(i)).y pts2_fin(cor2(i)).y],'o','Color',c);
end
