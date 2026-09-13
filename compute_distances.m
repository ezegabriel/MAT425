function Distances = compute_distances(data, X_0, Y_0)
    X = data(:, 1);
    Y = data(:, 2);
    A = (X - X_0).^2;
    B = (Y - Y_0).^2;

    Distances = sqrt(A + B);
end

