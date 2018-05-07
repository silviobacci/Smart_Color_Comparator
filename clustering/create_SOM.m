% ----------------------------------------------------------------------------------
% create_SOM creates different SOM network in order to cluster masters.
% ----------------------------------------------------------------------------------
function nets = create_SOM(LAB_tmp, dataset_portion)
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
    
    x = LAB_tmp(2:3,:);
    
    %% Local parameters 
    n_nets = 5;
    nets = cell(n_nets, 1);
    
    %% Creation of n_nets neural networks
    for dimension1 = 1 : n_nets
        dimension2 = floor(20 / dimension1);
        
        net = selforgmap([dimension1 dimension2]);

        % Disabling both prints on command line and window
        net.trainParam.showWindow = false;
        net.trainParam.showCommandLine = false;

        % Train the network 10 times
        for i = 1 : 10
            net = train(net,x);
        end
        
        nets{dimension1} = net;
    end
end