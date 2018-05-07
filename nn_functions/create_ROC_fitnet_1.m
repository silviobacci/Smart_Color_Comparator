function [net, accuracy, neurons, best_n] = create_ROC_fitnet_1(input, targets, hn_min, hn_max, hn_step, trains)
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

    if ~exist('trains','var')
        trains = 10;        % Number of trains to perform on the net at each iteration
    end
    
    %% Local variables containing: average MSE, average R-value and # of neuron
    
    n_classes = size(targets,2);

    neurons = zeros(floor((hn_max - hn_min + hn_step)/hn_step), 1);
    fuzzy_eval = neurons;
    accuracy= zeros(floor((hn_max - hn_min + hn_step)/hn_step), n_classes + 1);
    nets = cell(floor((hn_max - hn_min + hn_step)/hn_step), 1);
    results = zeros(size(t,1), size(t,2), floor((hn_max - hn_min + hn_step)/hn_step));
    
    %% Choose the Training Function

    % Choose a Training Function
    trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
    
    %% Body of the script consisting in 2 nested loops

    % Extern loop cycles among the # of neurons
    for hn = hn_min : hn_step : hn_max
        % Compute the number of the current iteration (i-th)
        i_n = (hn - hn_min)/hn_step + 1;

        % Save the number of neurones at the i-th iteration
        neurons(i_n) = hn;

        net = fitnet(hn, trainFcn);
        
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
            % Train the Network
            net = train(net,x,t);
            
            % Test the Network
            y = net(x);

            % Update the local variable by summing the results of all the tests
            tind = vec2ind(t);
            yind = vec2ind(y);
            for j = 1 : n_classes
                accuracy(i_n, j) = accuracy(i_n, j) + sum(yind(tind == j) == j)/sum(tind == j);
            end
            accuracy(i_n, n_classes + 1) = accuracy(i_n, n_classes + 1) + sum(tind == yind)/numel(tind);
            % Plots
            % Uncomment these lines to enable various plots.
            %figure, plotperform(tr)
            %figure, plottrainstate(tr)
            %figure, ploterrhist(e)
            %figure, plotconfusion(t,y)
            %figure, plotroc(t,y)
        end
        
        results(:,:,i_n) = y;
        
        % Update the waitbar
        percent = i_n/((hn_max - hn_min + hn_step)/hn_step);
        waitbar(percent,h,strcat('ROC Analysis (',num2str(floor(percent*100)),' %)'));

        if getappdata(h,'canceling')
            delete(h);
            return;
        end

        % Compute the average value dividing the results by the # of trains
        accuracy(i_n,:) = accuracy(i_n,:)./trains;
        nets{i_n} = net;
    end
    
    % Delete the waitbar
    delete(h);

    %% Compute the best net according to the fuzzy system
    
    fuzzy_evaluation = evalin('base','fuzzy_evaluation');
    for i = 1 : size(fuzzy_eval, 1)
        fuzzy_eval(i) = evalfis(accuracy(i,1:n_classes),fuzzy_evaluation);
    end

    %% Compute the best # of neurons minimizing error and maximing precision
    
    overall_accuracy = accuracy(:, n_classes + 1);

    best_n = find(accuracy(:,2) == max(accuracy(fuzzy_eval == max(fuzzy_eval),2)), 1);
    % [~,best_n] = max(overall_accuracy);

    fprintf('ROC ANALYSIS SOLUTION:\t\t NEURONS = %d \t\t ACCURACY = %f\n', neurons(best_n), overall_accuracy(best_n));

    %% Plot the Confusion matrix of the chosen network
    
    figure(1);
    plotconfusion(t,results(:,:,best_n));
    figure(2);
    plotroc(t,results(:,:,best_n))
    
    %% Plot the final result in one figure with 2 different plots

    title('ROC Accuracy');
    figure(3);
    yyaxis left
    plot(neurons,overall_accuracy,'-o');
    hold on
    scatter(neurons(best_n), overall_accuracy(best_n), 50, 'filled');
    xlabel('Neurons');
    hold off

    net = nets{best_n};
end