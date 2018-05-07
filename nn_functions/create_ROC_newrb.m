function [net, accuracy_n, neurons, best_n] = create_ROC_newrb(input, targets, hn_min, hn_max, hn_step)
    %% Create the waitbar

    h = waitbar(0,'ROC Analysis (0%)','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0);

    %% Loading of inputs and relative targets

    x = input';
    t = targets';

    %% Parameters of the script

    if ~exist('hn_min','var')
        hn_min = 1;         % Minimum number of hidden neuron to use
    end

    if ~exist('hn_max','var')
        hn_max = 100;       % Maximum number of hidden neuron to use
    end

    if ~exist('hn_step','var')
        hn_step = 10;       % Number of hidden neuron to add at each iteration
    end
    
    [~,s_min] = min_spread(input);
    [~, s_max] = max_spread(input);
    s_min = floor(s_min);
    s_max = floor(s_max);
    s_step = floor((s_max - s_min) / 10); 	% Spread value to add at each iteration

    goal = 0;       % Error we want to achieve during the training

    %% Local variables 
    
    % Setup Division of Data for Training, Validation, Testing
    net.divideFcn = 'divideind';
    train_index = size(evalin('base', 'train_samples'), 1);
    test_index = train_index + size(evalin('base', 'test_samples'), 1);
    valid_index = test_index + size(evalin('base', 'valid_samples'), 1);
    x_train = [x(:,1:1:train_index*4) x(:,test_index*4+1:valid_index*4)];
    x_test = x(:,train_index*4+1:test_index*4);
    t_train = [t(:,1:1:train_index*4) t(:,test_index*4+1:valid_index*4)];
    t_test = t(:,train_index*4+1:test_index*4);
    
    % Average MSE of the neurons, average R-value of the neurons and # of neurons

    n_classes = size(targets,2);

    accuracy_n = zeros(floor((hn_max - hn_min + hn_step)/hn_step), n_classes + 1);
    fuzzy_eval_n = zeros(floor((hn_max - hn_min + hn_step)/hn_step), 1);
    neurons = zeros(floor((hn_max - hn_min + hn_step)/hn_step), 1);
    nets_n = cell(floor((hn_max - hn_min + hn_step)/hn_step), 1);
    results_n = zeros(size(t_test,1), size(t_test,2), floor((hn_max - hn_min + hn_step)/hn_step));
     
    accuracy_s = zeros(floor((s_max - s_min + s_step)/s_step), n_classes + 1);
    spread = zeros(floor((s_max - s_min + s_step)/s_step), 1);
    results_s = zeros(size(t_test,1), size(t_test,2), floor((s_max - s_min + s_step)/s_step));
    fuzzy_eval_s = zeros(floor((s_max - s_min + s_step)/s_step), 1);
    nets_s = cell(floor((s_max - s_min + s_step)/s_step), 1);
        
    % Best spread for each # of hidden neurons used
    best_spread = zeros(floor((hn_max - hn_min + hn_step)/hn_step), 1);

    %% Body of the script consisting in 2 nested loops

    % Extern loop cycles among the # of neurons
    for hn = hn_min : hn_step : hn_max
        % Compute the number of the current iteration (i-th) among neurons
        i_n = (hn - hn_min)/hn_step + 1;

        % Save the number of neurones at the i-th iteration
        neurons(i_n) = hn;
        
        % Internal loop cycles among the spread's values
        for s = s_min : s_step : s_max
            % Compute the number of the current iteration (i-th) among spreads
            i_s = (s - s_min)/s_step + 1;

            % Save the spread at the i-th iteration
            spread(i_s) = s;

            % Create a RBF: "evalc" doesn't write on the command window all steps performed
            [~,net] = evalc('newrb(x_train,t_train,goal,s,hn,hn)');

            % Test the Network
            y = net(x_test);

            % Update the local variable by summing the results of all the tests
            tind = vec2ind(t_test);
            yind = vec2ind(y);
            for j = 1 : n_classes
                accuracy_s(i_s, j) = sum(yind(tind == j) == j)/sum(tind == j);
            end
            accuracy_s(i_s, n_classes + 1) = sum(tind == yind)/numel(tind);
            results_s(:,:,i_s) = y;
    
            nets_s{i_s} = net;
        end

        % Update the waitbar
        percent = i_n/((hn_max - hn_min + hn_step)/hn_step);
        waitbar(percent,h,strcat('ROC Analysis (',num2str(floor(percent*100)),' %)'));

        if getappdata(h,'canceling')
            delete(h);
            return;
        end
        
        fuzzy_evaluation = evalin('base','fuzzy_evaluation');
        for i = 1 : size(fuzzy_eval_s, 1)
            fuzzy_eval_s(i) = evalfis(accuracy_s(i,1:3), fuzzy_evaluation);
        end

        %% Compute the best # of neurons minimizing error and maximing precision

        best_n = find(accuracy_s(:,2) == max(accuracy_s(fuzzy_eval_s == max(fuzzy_eval_s),2)),1);
        % [~, best_n] = max(accuracy_s(:, n_classes + 1));
        
        accuracy_n(i_n, :) = accuracy_s(best_n, :);
        results_n(:,:,i_n) = results_s(:, :, best_n);
        nets_n{i_n} = nets_s{best_n};

        best_spread(i_n) = spread(best_n);
    end

    % Delete the waitbar
    delete(h);

    %% Compute the best # of neurons minimizing error and maximing precision
    
    overall_accuracy = accuracy_n(:, n_classes + 1);
    
    for i = 1 : size(fuzzy_eval_n, 1)
        fuzzy_eval_n(i) = evalfis(accuracy_n(i,1:3),fuzzy_evaluation);
    end

    %% Compute the best # of neurons minimizing error and maximing precision

    best_n = find(accuracy_n(:,2) == max(accuracy_n(fuzzy_eval_n == max(fuzzy_eval_n),2)), 1);
    % [~, best_n] = max(overall_accuracy);

    net = nets_n{best_n};

    fprintf('ROC ANALYSIS SOLUTION:\t NEURONS = %d \t SPREAD = %f \t ACCURACY = %f\n', neurons(best_n), best_spread(best_n), overall_accuracy(best_n));

    %% Plot the Confusion matrix of the chosen network
    
    figure;
    plotconfusion(t_test,results_n(:,:,best_n));
    figure;
    plotroc(t_test,results_n(:,:,best_n))
    
    %% Plot the final result in one figure with 2 different plots

    title('ROC Accuracy');
    figure;
    yyaxis left
    plot(neurons,overall_accuracy,'-o');
    hold on
    scatter(neurons(best_n), overall_accuracy(best_n), 50, 'filled');
    xlabel('Neurons');
    hold off
end