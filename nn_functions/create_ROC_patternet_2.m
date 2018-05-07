function [net, accuracy_e, neurons_e, best_n] = create_ROC_patternet_2(input, targets, hn_min, hn_max, hn_step, trains, hn_min2, hn_max2, hn_step2)
    %% Create the waitbar

    h = waitbar(0,'ROC Analysis (0 %)','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0);
    
    %% Loading of inputs and relative targets
    
    x = input';
    t = targets';
    
    %% Parameters of the script

    if ~exist('hn_min','var')
        hn_min = 1;         % Minimum number of hidden neuron to use
    end

    if ~exist('hn_max','var')
        hn_max = 201;       % Maximum number of hidden neuron to use
    end

    if ~exist('hn_step','var')
        hn_step = 10;       % Number of hidden neuron to add at each iteration
    end
    
    if ~exist('hn_min2','var')
        hn_min2 = 1;         % Minimum number of hidden neuron to use
    end

    if ~exist('hn_max2','var')
        hn_max2 = 5;       % Maximum number of hidden neuron to use
    end

    if ~exist('hn_step2','var')
        hn_step2 = 1;       % Number of hidden neuron to add at each iteration
    end

    if ~exist('trains','var')
        trains = 10;        % Number of trains to perform on the net at each iteration
    end
    
    %% Local variables containing: average MSE, average R-value and # of neuron
    
    n_classes = size(targets,2);

    neurons_e = zeros(floor((hn_max - hn_min + hn_step)/hn_step), 2);
    fuzzy_eval_e = zeros(floor((hn_max - hn_min + hn_step)/hn_step), 1);
    accuracy_e = zeros(floor((hn_max - hn_min + hn_step)/hn_step), n_classes + 1);
    nets_e = cell(floor((hn_max - hn_min + hn_step)/hn_step), 1);
    results_e = zeros(size(t,1), size(t,2), floor((hn_max - hn_min + hn_step)/hn_step));
    results_i = zeros(size(t,1), size(t,2), floor((hn_max2 - hn_min2 + hn_step2)/hn_step2));
    neurons_i = zeros(floor((hn_max2 - hn_min2 + hn_step2)/hn_step2), 1);
    
    %% Choose the Training Function

    % Choose a Training Function
    trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
    
    
    %% Body of the script consisting in 2 nested loops

    % Extern loop cycles among the # of neurons
    for hn = hn_min : hn_step : hn_max
        % Compute the number of the current iteration (i-th)
        i_n1 = (hn - hn_min)/hn_step + 1;
        
        neurons_e(i_n1, 1) = hn;
        
        fuzzy_eval_i = zeros(floor((hn_max2 - hn_min2 + hn_step2)/hn_step2), 1);
        accuracy_i = zeros(floor((hn_max2 - hn_min2 + hn_step2)/hn_step2), n_classes + 1);
        nets_i = cell(floor((hn_max2 - hn_min2 + hn_step2)/hn_step2), 1);
        
        for hn2 = hn_min2 : hn_step2 : hn_max2
            % Compute the number of the current iteration (i-th)
            i_n2 = (hn2 - hn_min2)/hn_step2 + 1;
            
            neurons_i(i_n2) = hn2;

            net = patternnet([hn hn2], trainFcn);

            % Disabling both prints on command line and window
            net.trainParam.showWindow = false;
            net.trainParam.showCommandLine = false;

            % Setup Division of Data for Training, Validation, Testing
            net.divideFcn = 'divideind';
            train_index = size(evalin('base', 'train_samples'), 1);
            test_index = train_index + size(evalin('base', 'test_samples'), 1);
            valid_index = test_index + size(evalin('base', 'valid_samples'), 1);
            [net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd] = divideind(size(targets,1), 1:train_index*4, test_index*4+1:valid_index*4, train_index*4+1:test_index*4);

            % Internal loop performs "trains" times the train of the network
            for i = 1 : trains
                rng(i);
                % Train the Network
                net = train(net,x,t);

                % Test the Network
                y = net(x);

                % Update the local variable by summing the results of all the tests
                tind = vec2ind(t);
                yind = vec2ind(y);
                for j = 1 : n_classes
                    accuracy_i(i_n2, j) = accuracy_i(i_n2, j) + sum(yind(tind == j) == j)/sum(tind == j);
                end
                accuracy_i(i_n2, n_classes + 1) = accuracy_i(i_n2, n_classes + 1) + sum(tind == yind)/numel(tind);
            end

            results_i(:,:,i_n2) = y;
            
            nets_i{i_n2} = net;

            % Compute the average value dividing the results by the # of trains
            accuracy_i(i_n2,:) = accuracy_i(i_n2,:)./trains;
        end
        
        fuzzy_evaluation = evalin('base','fuzzy_evaluation');
        for i = 1 : size(fuzzy_eval_i, 1)
            fuzzy_eval_i(i) = evalfis(accuracy_i(i,1:3), fuzzy_evaluation);
        end

        %% Compute the best # of neurons minimizing error and maximing precision

        best_n = find(accuracy_i(:,2) == max(accuracy_i(fuzzy_eval_i == max(fuzzy_eval_i),2)),1);
        % [~, best_n] = max(accuracy_i(:, n_classes + 1));
        
        accuracy_e(i_n1, :) = accuracy_i(best_n, :);
        results_e(:,:,i_n1) = results_i(:,:,best_n);
        nets_e{i_n1} = nets_i{best_n};
        
        neurons_e(i_n1, 2) = neurons_i(best_n);
        
        % Update the waitbar
        percent = i_n1/((hn_max - hn_min + hn_step)/hn_step);
        waitbar(percent,h,strcat('ROC Analysis (',num2str(floor(percent*100)),' %)'));

        if getappdata(h,'canceling')
            delete(h);
            return;
        end
    end
    
    % Delete the waitbar
    delete(h);

    %% Compute the best # of neurons minimizing error and maximing precision
    
    overall_accuracy = accuracy_e(:, n_classes + 1);
    
    for i = 1 : size(fuzzy_eval_e, 1)
        fuzzy_eval_e(i) = evalfis(accuracy_e(i,1:3),fuzzy_evaluation);
    end

    %% Compute the best # of neurons minimizing error and maximing precision

    best_n = find(accuracy_e(:,2) == max(accuracy_e(fuzzy_eval_e == max(fuzzy_eval_e),2)), 1);
    % [~, best_n] = max(overall_accuracy);
    
    net = nets_e{best_n};

    fprintf('ROC ANALYSIS SOLUTION:\t\t NEURONS_1 = %d \t\t NEURONS_2 = %d \t\t ACCURACY = %f\n', neurons_e(best_n, 1), neurons_e(best_n, 2), overall_accuracy(best_n));

    %% Plot the Confusion matrix of the chosen network
    
    figure(1);
    plotconfusion(t,results_e(:,:,best_n));
    figure(2);
    plotroc(t,results_e(:,:,best_n))
    
    %% Plot the final result in one figure with 2 different plots

    title('ROC Accuracy');
    figure(3);
    yyaxis left
    plot(neurons_e(best_n, 1),overall_accuracy,'-o');
    hold on
    scatter(neurons_e(best_n, 1), overall_accuracy(best_n), 50, 'filled');
    xlabel('Neurons');
    hold off
end