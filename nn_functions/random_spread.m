function [centers, out_centers, spread] = random_spread(input, target, n, index)
    [centers, out_centers] = random_trainset(input, target, n, index);
    
    % Compute the maximum value of the spread
    spread = max_spread(centers');
end