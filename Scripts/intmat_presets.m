nt_vals = linspace(9100, 10000, 10);

load("intmats.mat", "mats");

for nt = nt_vals
    disp("Creating matrix [nt = " + nt + "]");
    imat = intmat([nt, nt], 1, [0, 10]);
    eval("m" + nt + " = imat;");
    save("intmats.mat", "m" + nt, "-append");
    if sum(nt == mats) == 0
        mats(end + 1) = nt;
    end

    % d{int2str(nt)} = intmat([nt, nt], 1, [0, 10]);
end

save("intmats.mat", "mats", "-append");

% save("intmats.mat", "d");

% sum = 0;
% for k = keys(d).'
%     disp("Running loop");
%     dk = d{k};
%     s = whos("dk").bytes;
%     disp("(key = " + k + ") size = " + s);
%     sum = sum + s;
% end
% 
% disp("sum: " + sum);