function [spread, min_distance] = min_spread(input)
    D = pdist2(input, input);
    min_distance = min(D(D>0));
    spread = min_distance / sqrt(size(input,1));
end