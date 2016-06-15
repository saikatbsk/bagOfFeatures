%% ========================================================================
%% Reads a dataset of images(JPG). Sub folders containing different classes
%% of images are kept within a root folder.
%%
%% Parameters:
%%      rootpath        - Path to root folder.
%%      subfolders      - Sub folders within root folder.
%%      image_per_class - Number of images per class.
%%
%% Returns:
%%      imageset        - Set of images.
%% ========================================================================

function imageset = imageRead(rootpath, subfolders, image_per_class)
    for i = 1:size(subfolders, 2)
        fn = { dir(fullfile(rootpath, char(subfolders(i)), '*.jpg')).name };

        if size(fn, 2) < image_per_class
            fprintf('\n\n>>> ERROR! Number of images in folder is less than %d\n\n', image_per_class); fflush(stdout);
            return;
        end

        for j = 1:image_per_class
            imageset(i, j) = fullfile(rootpath, char(subfolders(i)), fn(j));
        end
    end
end
