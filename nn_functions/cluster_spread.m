% ----------------------------------------------------------------------------------
% cluster_spread finds k centres using k-means and computes the spread by
% normalization.
% ----------------------------------------------------------------------------------
function [centers, out_centers, spread] = cluster_spread(input, target, k, i)
    centers = zeros(k,size(input,2));
    out_centers = zeros(k,size(target,2));
    
    rng(i);
    % Compute k-clusters by using the k-means algorithm
    [~,c] = kmeans(input,k);
    
    for i = 1 : k
        % Compute the distance between centroid of the current cluster and each point of the input
        D = pdist2(c(i,:), input);
        
        % Find the nearest point to the centroid
        [~, index] = min(D);
        
        % Insert the point in the set of the centres
        centers(i,:) = input(index,:);
        out_centers(i,:) = target(index,:);
        
        % Create an array of booleans with false in 'index'
        indexes = true(size(input,1),1);
        indexes(index) = false;
        
        % Eliminate the 'index' row from the set of inputs and targets
        input = input(indexes,:);
        target = target(indexes);
    end
    
    % Compute the maximum value of the spread
    spread = max_spread(centers);
    
    % Transpose the matrixes in order to be accepted by the newrb/newrbe functions
    centers = centers';
    out_centers = out_centers';
end