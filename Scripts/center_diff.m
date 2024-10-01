%% Center Difference Function %%

function out = center_diff(vals, dx, n)
    % First partial derivative
    if (n == 1)
        out = zeros(length(vals), 1);
        for i = 2:length(vals) - 1
            out(i) = (vals(i+1) - vals(i-1)) / (2*dx);
        end
        out = out(:);
    end

    % Second partial derivative
    if (n == 2)
        out = zeros(1, length(vals));
        for i = 2:length(vals) - 1
            out(i) = (vals(i+1) - 2*vals(i) + vals(i-1)) / (dx^2);
        end
        out = out(:);
    end
end