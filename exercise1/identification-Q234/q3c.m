
histograms = {'grayvalue'; 'dxdy'; 'rg'; 'rgb'};
distances = {'chi2'; 'intersect'; 'l2'};
%distances = {'chi2'; 'l2'};


model_images = textread('model.txt', '%s');
query_images = textread('query.txt', '%s');

fprintf('loaded %d model images\n', length(model_images));
fprintf('loaded %d query images\n', length(query_images));

%maybe do more than hardcoding the number of bins?
num_bins = 30;

bins = {10; 15; 20; 30; 50; 100};

res = zeros(length(histograms), length(distances), length(bins));

for h = 1:length(histograms)
  for d = 1:length(distances)
    for b = 1:length(bins)
      bins{b}
      distances{d}
      histograms{h}
      [best_match, D] = find_best_match(model_images, query_images, distances{d}, histograms{h}, bins{b});

      num_correct = sum(best_match == 1:length(query_images));
      acc = num_correct / length(query_images);
      fprintf('number of correct matches: %d (%f)\n', num_correct, acc);
      res(h, d, b) = acc;

    end
  end
end

res
