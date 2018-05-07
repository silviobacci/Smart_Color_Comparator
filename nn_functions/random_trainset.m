function [x, t] = random_trainset(input, target, n, index)
    x = zeros(n,size(input,2));
    t = zeros(n,size(target,2));
    rng(index);
    i_indexes = randperm(size(input,1),n);
    
    for i = 1 : n
        % Insert the point in the set of the centres
        x(i,:) = input(i_indexes(i),:); 
        t(i) = target(i_indexes(i));
    end
    
    % Transpose the matrixes in order to be accepted by the newrb/newrbe functions
    x = x';
    t = t';
end