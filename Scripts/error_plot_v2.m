nt_range = linspace(1000, 10000, 10);
N = length(nt_range);
J = 3;

errors = zeros(N, J + 1);
for i = 1:N
    nt = nt_range(i);
    tvec = chebpts(nt, [0, 10]);
    act = cos(tvec.');
    for j = 0:J
        disp("Solving [N = " + nt_range(i) + "][J = " + j + "]");
        ymat = solve(RHS.trig, tvec, [1; 0], j, true);
        errors(i, j + 1) = norm(ymat(1, end) - act(end));
    end
end

figure();
names = cell(1, J + 1);
for j = 1:(J + 1)
    names(j) = {append('j = ', num2str(j - 1))};
end
loglog(nt_range, abs(errors))
legend(names)
grid on