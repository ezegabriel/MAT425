X = [1,2,3]
Y = [2,4,6]

for i = 1:length(X)
    h = X(i) + Y(i);
    fprintf('Sum of X(%d) and Sum of Y(%d) is: %d\n', i, i, h)
end
x = linspace(0,10,100);
y = sin(x);

figure;
hold on;
plot(x, y);

scatter(X, Y);
title('Example Help');
hold off;

% Inputs
X = input('Enter an even number of elements :') % i.e. [1, 2, 3]

Y = zeros(1, length(X));

f(X) = X.^2;
g(X) = 2*X + 1;

for i = 1:length(X) / 2
    Y(i) = f(X(i));
end

for i = length(X)/2 + 1:length(X)
    Y(i) = g(X(i));
end

Y