%% SDC Function %%

function out = run_sdc(ymat, func, tvec, J, stiff, dx, debug)
    arguments
        ymat; func; tvec; J; stiff; dx;
        debug = false;
    end
    if (J >= 1)
        % Load correct int_matrix from file, if applicable
        if (debug); disp("Loading in intmat"); end
    
        nt = size(ymat, 2);
        load("intmats.mat", "mats");
        if sum(mats == nt) > 0
            load("intmats.mat", "m" + nt);
            eval("int_matrix = m" + nt + ";");
        else
            if (debug); disp("Creating new intmat"); end
            int_matrix = intmat([nt, nt], 1, [0, 10]);
        end
    end

    % SDC Loop
    for j = 1:J
        if (debug); disp("Computing Resid [j = " + j + "]"); end
        res_mat = compute_resid(ymat, func, tvec, dx, int_matrix);
        res_diff = res_mat - [res_mat(:, 1), res_mat(:, 1:end - 1)];
        % assignin('base', 'res', res_mat);
        if (debug); disp("Running Euler [j = " + j + "]"); end
        error_mat = run_euler(res_diff, G(func), ...
            tvec, stiff, {ymat, dx});
        % assignin('base', 'err', error_mat);
        ymat = ymat + error_mat;
    end

    out = ymat;
end

% Requires: func, tvec, dx
function out = compute_resid(ymat, func, tvec, dx, int_matrix)
    % Assign nx and nt based on ymat
    % nx = size(ymat, 1);
    % nt = size(ymat, 2);

    % Calculate derivative at each point and time

    % For Loop
    % derivative = zeros(nx, nt);
    % for i = 1:nt
    %     derivative(:, i) = func(tvec(i), ymat(:, i), dx);
    % end
    
    % Vectorized
    derivative = func(tvec.', ymat, dx);

    % For each point in space (each row of derivative),
    % take integral over time using spectral integration
    % int_matrix = intmat([nt, nt], 1, [tvec(1), tvec(end)]);

    % For Loop
    % integral = zeros(nx, nt);
    % for i = 1:nx
    %     integral(i, :) = (int_matrix * ...
    %         derivative(i, :).').' + ymat(i, 1);
    % end

    % Vectorized
    integral = (int_matrix * derivative.' + ymat(:, 1).').';

    out = integral - ymat;
end

% Derivative difference function
function out = G(func)
    % y is delta_mat, args(1) is ymat, args(2:end - 1) are dx, etc.
    % and args(end) is i
    out = @(t, y, args) func(t, args{1}(:, args{end}) + y, args(2:end - 1)) - ...
        func(t, args{1}(:, args{end}), args(2:end - 1));
end