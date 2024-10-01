time_limits = linspace(0.1, 1, 10);
% time_limits = 1;
N = length(time_limits);
J = 3;

func = RHS.trig;
y0 = [1; 0];
stiff = true;
T = [0, 10];

errors = zeros(N, J + 1);
nt_vals = zeros(N, J + 1);

initial_nt_nosdc = 0; % The initial value to be calculated for no SDC
for i = 1:500
    tvec = chebpts(1.1 ^ i, T);
    tic;
        solve(func, tvec, y0, 0, stiff);
    time = toc;
    if time > 0.09
        disp(time);
        initial_nt_nosdc = 1.1 ^ i;
        break;
    end
end

disp(initial_nt_nosdc);

for i = 1:N
    for j = flip(1:J)
        best = Inf;
        time = 0;

        if i == 1
            if j == J
                nt = 100;
            else
                nt = nt_vals(i, j + 2);
            end
        else
            if j == J
                nt = nt_vals(i - 1, j + 1);
            else
                nt = max(nt_vals(i - 1, j + 1), nt_vals(i, j + 2));
            end
        end

        disp("Initial value of nt = " + nt);

        for k = 1:100
            tvec = chebpts(nt + 100 * (k - 1), T);
            disp("nt = " + length(tvec));
            tic;
                ymat = solve(func, tvec, y0, j, stiff);
            time = toc;
            if time > time_limits(i)
                disp("[i=" + i + ",j=" + j + ",k=" + k + "] " + time);
                nt_vals(i, j + 1) = nt + 100 * (k - 1);
                errors(i, j + 1) = abs(ymat(1, end) - cos(T(2)));
                break;
            end
        end

        while (time <= time_limits(i))
            tvec = chebpts(nt, T);
            ymat = solve(func, tvec, y0, j, stiff);
            nt = nt + 100;
        end

        % Set nt value
        % Set error
    end
    % Run for j = 0
    if i == 1
        nt = initial_nt_nosdc;
    else
        nt = nt_vals(i - 1, 1);
    end

    for k = 1:500
        tvec = chebpts(nt * (1.04 ^ k), T);
        tic;
            ymat = solve(func, tvec, y0, 0, stiff);
        time = toc;
        if time > time_limits(i)
            disp(time);
            nt_vals(i, 1) = nt * (1.04 ^ k);
            errors(i, 1) = abs(ymat(1, end) - cos(T(2)));
            break;
        end
    end
end

figure();
names = cell(1, J + 1);
for j = 1:(J + 1)
    names(j) = {append('j = ', num2str(j - 1))};
end
semilogy(time_limits, abs(errors));
legend(names)  
grid on