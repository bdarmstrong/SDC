%% Euler Function %%

function mat = run_euler(mat, func, tvec, stiff, args)
    arguments
        mat;
        func; % Takes parameters time, yvec, args
        tvec;
        stiff;
        args = 0;
    end

    % Instantiate vars
    hvec = [tvec(2:end); tvec(end)] - tvec;
    nx = size(mat, 1);
    nt = size(mat, 2);

    if (~stiff)
        % Explicit euler
        for i = 1:(nt - 1)
            mat(:, i + 1) = mat(:, i + 1) + mat(:, i) + ...
                hvec(i) .* func(tvec(i), mat(:, i), [args, i]);
        end
    else
        % Implicit euler
        tol = 1.e-50; % These are hardcoded... how to fix?
        dz = zeros(nx, 1) + 0.000001; % Make this relative?
        for i = 1:(nt - 1)
        % for i = 1:5
            z0 = mat(:, i + 1) + mat(:, i) + ...
                hvec(i) .* func(tvec(i), mat(:, i), [args, i]);
            for j = 1:50
                % df = zeros(length(z0), 1);
                % for k = 1:length(z0)
                %     dzv = zeros(length(z0), 1);
                %     dzv(k) = dz;
                %     temp = (func(tvec(i + 1), z0 + dzv, [args, i]) - ...
                %         func(tvec(i + 1), z0 - dzv, [args, i])) ...
                %         ./ (2 * dz);
                %     df(k) = temp(k);
                % end

                % Only works for ODE
                df = (func(tvec(i + 1), z0 + dz, [args, i]) - ...
                      func(tvec(i + 1), z0 - dz, [args, i])) ...
                      ./ (2 * dz);

                g = z0 - (mat(:, i + 1) + mat(:, i) + ...
                    hvec(i + 1) .* func(tvec(i + 1), z0, [args, i]));

                gp = 1 - hvec(i + 1) .* df;

                ud = g ./ gp;

                zn = z0 - ud;

                % if (i == 5 && j == 1)
                %     assignin('base','df',df);
                %     assignin('base','dz',dz);
                %     assignin('base','z0',z0);
                %     assignin('base','zn', zn);
                %     assignin('base','g',g);
                %     assignin('base','gp', gp);
                %     assignin('base', 'ud', ud);
                % end

                % disp("Hello")
                % disp(g)
                % disp(gp)
                % disp(z0);
                % disp(zn);
                % disp(func(tvec(i), mat(:, i), [args, i]));
                % disp(func(tvec(i + 1), z0, [args, i]));

                z0 = zn;

                % 
                % if (i <= 3)
                %     disp("UD");
                %     disp(i)
                %     disp(j)
                %     disp(ud);
                % end

                if (norm(ud) < tol)
                    % disp("[" + i + "] " + "Implicit Euler Converged (j = " + j + ")")
                    break
                end

                if (j > 49)
                    % disp("[" + i + "] " + "Implicit Euler Failed to Converge")
                end
            end
            mat(:, i + 1) = zn;
        end
    end
end