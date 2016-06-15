%% ========================================================================
%% Display the confusion matrix and accuracy of experiment.
%% ========================================================================

fprintf('Confusion Matrix:\n\n'); fflush(stdout);

for i = 1:((size(class_names, 2) * 10) / 2)
    fprintf(' ');
end

fprintf('PREDICTED\n'); fflush(stdout);

fprintf('KNOWN     | ');

for i = 1:size(class_names, 2)
    th = char(class_names(i));

    if length(th) > 9
        th = strcat(th(1:7), '..');
    end

    fprintf('%9s ', th);
end

fprintf('\n'); fflush(stdout);

for i = 1:((size(class_names, 2) + 1) * 10) + 1
    fprintf('-');
end

fprintf('\n'); fflush(stdout);

for i = 1:size(conf_mat, 1)
    th = char(class_names(i));

    if length(th) > 9
        th = strcat(th(1:7), '..');
    end

    fprintf('%9s | ', th);

    for j = 1:size(conf_mat, 1)
        fprintf('%9.2f ', conf_mat(i, j));
    end

    fprintf('\n'); fflush(stdout);
end

fprintf('\n'); fflush(stdout);

d   = diag(conf_mat);
acc = (sum(d) / length(class_names)) * 100;

fprintf('Accuracy: %.2f %%\n', acc); fflush(stdout);

fprintf('\n'); fflush(stdout);
