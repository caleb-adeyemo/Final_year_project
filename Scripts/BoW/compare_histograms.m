function [res] = compare_histograms(hist1, hist2)
% Chi_value
A = hist1 + 1;  % Add a +1 to avoid division by 0
B = hist2 + 1;  % Add a +1 to avoid division by 0

mean_value = (A + B)/2;

res = sum((((A-mean_value).^2)./mean_value));

end

