%% Solve Function %%

function out = solve(func, tvec, y0, J, stiff, X, debug)
    arguments
        func;
        tvec;
        y0;
        J = 1;
        stiff = false;
        X = [-10, 10]; % Assumes points are evenly spatially distributed
        debug = false;
    end

    % Calculate nx, nt, and dx
    nx = length(y0);
    nt = length(tvec);
    dx = (X(2) - X(1)) / nx;

    % Instantiate ymat
    ymat = zeros(nx, nt);
    ymat(:, 1) = y0;

    % Run euler method
    ymat = run_euler(ymat, func, tvec, stiff, dx);

    % Run SDC
    out = run_sdc(ymat, func, tvec, J, stiff, dx, debug);
end