classdef RHS
    methods (Static)
        % Methods which return corresponding anonymous function
        function out = expo()
            out = @(t, y, args) y;
        end

        function out = trig()
            out = @(t, y, args) [...
                -16 * y(1, :) + 12 * y(2, :) + 16 * cos(t) - 13 * sin(t); ...
                12 * y(1, :) - 9 * y(2, :) - 11 * cos(t) + 9 * sin(t)];
        end
        % See https://math.stackexchange.com/questions/4538367/stiff-system-of-odes-with-known-exact-solutions
        % With x0 = 1, y0 = 0, solution is x = cos(t), y = sin(t)

        function out = lv()
            a = 1.1; b = 0.4; d = 0.1; g = 0.4;
            out = @(t, y, args) [a * y(1, :) - b * y(1, :) * y(2, :); ...
                d * y(1, :) * y(2, :) - g * y(2, :)];
        end
        % Explicit Euler blows up with T = [0, 100] and nt <= 1149, but not at nt >= 1150
        % Solution starts to get weird at the spot of blowup around 1250
        % Implicit Euler has similar blowup under same conditions, but at nt = 190


        function out = cyt2()
            c = 2;
            out = @(t, y, args) c * y + t .^ 2;
        end
        % Note: At high values of h ~ 0.1, explicit performed much better,
        % but at low values of h ~ 0.001, implicit pereformed much better

        function out = lor()
            % Lorenz System
        end

        function out = van()
            % Van der Pol Oscillator
        end

        function out = heat1d()
            out = @(t, y, args) center_diff(y, args{1}, 2);
        end
    end
end

