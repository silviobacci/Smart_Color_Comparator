function [spread, max_distance] = max_spread(input)
    D = pdist2(input, input);
    max_distance = max(D(D>0));
    spread = max_distance / sqrt(size(input,1));
end