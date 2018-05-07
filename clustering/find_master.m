% ----------------------------------------------------------------------------------
% find_master searches a subset of the entire master universe. The subset is chosen
% considering a settable percentage (i.e. dataset_portion) and the subset is found 
% looking for the masters that are more distant from the other ("uniform"
% distribution of the masters). Then we try to identify a proper number
% clusters e inside each cluster we use 70% of masters for traing, 15% for testing
% and 15% for validating.
% ----------------------------------------------------------------------------------

function [train, test, valid, id_ret, xb_index, centres] = find_master(LAB, dataset_portion)
    train_portion = 0.7;
    test_portion = 0.15;
    valid_portion = 0.15;
    
    LAB_tmp = LAB;
    
    %% Compute the distance between each pair of points
    distance = zeros(size(LAB_tmp,2), size(LAB_tmp,2));
    for i = 1 : size(LAB_tmp,2)
        distance(i,:) = pdist2(LAB_tmp(:,i)', LAB_tmp');
    end
    distance = triu(distance);
    distance(distance == 0) = inf;
    
    %% Compute the number of masters we are looking for
    to_take = floor(size(LAB_tmp,2) * dataset_portion);
        
    %% Search the masters that are farest from the others
    for j = 1 : size(LAB_tmp,2) - to_take
        [~, index] = min(min(distance));
        distance(:, index) = inf;
        LAB_tmp(:, index) = inf;
    end
    [~, col] = find(LAB_tmp ~= inf);
    col = unique(col);
    LAB_tmp = LAB_tmp(:,col);
    
    %% Identify the "best" number of clusters in the set wuing the Xie_Beni index
    xb_index = -ones(11,1);
    for j = 10 : 20
        rng(j);
        [id, c] = kmeans(LAB_tmp(2:3,:)', j, 'distance','sqEuclidean', 'Replicates', 3);
        xb_index(j-9) = validity(LAB_tmp(2:3,:)', id, c);
    end
    [~,k] = min(xb_index);
    k = k + 10;
    rng(k);
    [id, centres] = kmeans(LAB_tmp(2:3,:)', k, 'distance','sqEuclidean', 'Replicates', 3);

    %% Create return vectors and relative parameters
    train = -ones(floor(size(LAB,2) * dataset_portion * train_portion), 1);
    test = -ones(floor(size(LAB,2) * dataset_portion * test_portion), 1);
    valid = -ones(floor(size(LAB,2) * dataset_portion * valid_portion), 1);
    id_ret = zeros(1232,1);
    
    train_index = 1;
    test_index = 1;
    valid_index = 1;
    
    %% For each cluster, divide it in masters for training, testing and validating
    for i = 1 : k
        points = LAB_tmp(:, id == i);
        
        % Takes the number of points to use as test samples
        n_points = size(points,2);
        if(norm(test_portion * n_points - round(test_portion * n_points)) < 0.1)
            to_take = round(test_portion * n_points);
        else
            to_take = floor(test_portion * n_points);
        end
        
        % Choose randomly test samples
        rng(i);
        A = points(:,randperm(n_points, to_take))';
        B = LAB';
        [~,ind] = intersect(B, A, 'rows');
        test(test_index : test_index + to_take - 1) = ind;
        test_index = test_index + to_take;
        id_ret(ind) = i;
        rng(i);
        points = removerows(points',randperm(n_points, to_take));
        points = points';
        
        % Takes the number of points to use as validation samples
        remaining_portion = valid_portion / (1 - test_portion);
        n_points = size(points,2);
        if(norm(remaining_portion * n_points - round(remaining_portion * n_points)) < 0.1)
            to_take = round(remaining_portion * n_points);
        else
            to_take = floor(remaining_portion * n_points);
        end
        
        % Choose randomly validation samples
        rng(i);
        A = points(:,randperm(n_points, to_take))';
        [~,ind] = intersect(B, A, 'rows');
        valid(valid_index : valid_index + to_take - 1) = ind;
        valid_index = valid_index + to_take;
        id_ret(ind) = i;
        rng(i);
        points = removerows(points', randperm(n_points, to_take));
        points = points';
        
        % Use the remaining points as train samples
        n_points = size(points,2);
        A = points';
        [~,ind] = intersect(B, A, 'rows');
        train(train_index : train_index + n_points - 1) = ind;
        train_index = train_index + n_points;
        id_ret(ind) = i;
    end

    train = train(train>0);
    test = test(test>0);
    valid = valid(valid>0);
    
    train = sort(train);
    test = sort(test);
    valid = sort(valid);
end
