% Lagrange Interpolation
% need Symbolic Toolbox: Home-> Add-Ons->Get Add-Ons-> Symbolic Toolbox
clear all
syms x
X = input('Enter the x values as an array :') % i.e. [1, 2, 3]
Y = input('Enter the y values as an array :')
n = length(X);
Pn = 0;
for i = 1:n
    L = 1;
    for j = 1:n
        if (i~=j)
            L = L*(x-X(j))/(X(i)-X(j));
        end
    end
    Pn = Pn +Y(i)*L;
end
polynomial = simplify(Pn)

% Convert symbolic expression to function handle for plotting
f = matlabFunction(polynomial, 'Vars', x);

% Define fine grid for smooth curve
x_plot = linspace(min(X) - 1, max(X) + 1, 1000);
y_plot = f(x_plot);

% Plot data points and interpolation polynomial
figure;
plot(x_plot, y_plot, 'b-', 'LineWidth', 2); % Plot polynomial
hold on;
plot(X, Y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Plot data points
xlabel('x');
ylabel('y');
title('Lagrange Interpolation Polynomial');
grid on;
legend('Interpolant Polynomial', 'Data Points');
hold off;