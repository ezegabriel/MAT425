load dataset.mat data
X_0 = 5;
Y_0 = 5;
Distances = compute_distances(data, X_0, Y_0)

figure(1)
hold on;
scatter(data(:, 1), data(:, 2))
scatter(X_0, Y_0)

hold off;
figure(2)
bar(Distances)
ylabel('Distance')