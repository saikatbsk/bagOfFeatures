%% ========================================================================
%% Returns SURF feature points as images.
%%
%% Parameters:
%%      image - Path to image.
%%      ptr   - Interest point.
%%
%% Returns:
%%      I     - Cropped image.
%% ========================================================================

function I = featureAsImage(image, ptr)
    S = fix(2.5 * ptr.scale);

    x = ptr.x;
    y = ptr.y;

    I = imcrop(image, [x-S, y-S, 2*S, 2*S]);
end
