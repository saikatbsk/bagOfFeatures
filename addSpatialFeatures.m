function comb_features = addSpatialFeatures(pts, img)
    comb_features = [];
    C = [mean([pts.x])/size(img, 2) mean([pts.y])/size(img, 1)];

    for i = 1:size([pts.descriptor], 2)
        spat_features = [];

        x_norm = [pts(i).x]/size(img, 2);
        y_norm = [pts(i).y]/size(img, 1);

        P = [x_norm y_norm];
        D = euclideanDistance(C, P);

        spat_features = [D];

        cx = C(1); cy = C(2);

        if x_norm < cx && y_norm < cy
            spat_features = [spat_features; 0];
        elseif x_norm >= cx && y_norm < cy
            spat_features = [spat_features; 1];
        elseif x_norm >= cx && y_norm >= cy
            spat_features = [spat_features; 2];
        elseif x_norm < cx && y_norm >= cy
            spat_features = [spat_features; 3];
        end

        comb_features = [comb_features, [pts(i).descriptor; spat_features]];
    end
end
