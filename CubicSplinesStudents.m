% Cubic Splines
clear all
format long

% Inputs
X = input('Enter the x values as an array :') % i.e. [1, 2, 3]
Y = input('Enter the y values as an array :')

n = length(X);

% creating the vector a for aj's
a=Y;

% creating the vector H -h0, h1, h2, ...
for i=1:n-1
    H(i)=X(i+1)-X(i);
    disp(i+5);
end

% creating the linear equations system in the form of AC=B
% creating the matrix A
A(1,1)=1; A(n,n)=1;
for i=2:n-1
    A(i,i)=2*(H(i-1)+H(i));
    A(i,i-1)=H(i-1);
    A(i,i+1)=H(i);
end

% creating the matrix B
B(1)=0; B(n)=0;
for i=2:n-1
    B(i)=(3/H(i))*(a(i+1)-a(i))-(3/H(i-1))*(a(i)-a(i-1));
end

%% Calculating the coefficients of cubic splines

% calculating cj's
C=inv(A)*B';
c=C';

% calculating dj's
for j=1:n-1
    d(j)=(c(j+1)-c(j))/(3*H(j));
end

% calculating bj's
for j=1:n-1
    b(j)=(1/H(j))*(a(j+1)-a(j))-(H(j)/3)*(2*c(j)+c(j+1));
end

% output n number of splines
fprintf('\n\n ******* splines are ******* \n\n');
for j=1:n-1
    fprintf('S%1.0f(x)=%5.4f+%5.4f(x-%5.2f)+%5.4f(x-%5.2f)^2+%5.4f(x-%5.2f)^3',(j-1),a(j),b(j),X(j),c(j),X(j),d(j),X(j))
    fprintf('\n')
end



figure;     % Open a new figure window
plot(X, Y, 'rh');      % Plot the data circles as red circles
hold on;    % keep data points visible

% Create partition, initialize storage vector, plot splines through
for j = 1:n-1

    % Partition on given domain
    x_vals = X(j):.001:X(j + 1);

    % Compute predicted y-values, store to a matrix
    spline_vals = a(j) + b(j)*(x_vals - X(j)) + c(j)*(x_vals - X(j)) .^ 2 + d(j)*(x_vals - X(j)) .^ 3;

    % Plot the spline arc
    plot(x_vals, spline_vals);
end

grid on;
xlabel('X');
ylabel('Y');
title('Cubic Spline Plot');
hold off;