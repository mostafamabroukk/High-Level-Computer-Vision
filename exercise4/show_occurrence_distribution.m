function show_occurrence_distribution(cluster_occurrences, cluster_idx)

relevant_occurrences = cluster_occurrences(cluster_occurrences(:, 1) == cluster_idx, 2:3);

figure(200+cluster_idx)
hold on

scatter([0], [0], 'go')

scatter(relevant_occurrences(:, 1), -1*relevant_occurrences(:, 2), 'b+')

hold off

  % ...