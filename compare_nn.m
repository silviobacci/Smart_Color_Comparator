load CI_dataset_new.mat;
load CI_copy_evaluation_2.mat;
load CI_fuzzy_evaluation.mat;

wl_step = 2;

hn_min = 2;
hn_max = 100;
hn_step = 1;

trains = 10;

hn_min2 = 1;
hn_max2 = 20;
hn_step2 = 1;

[input, targets] = compute_input_target(master_rSPD, copy_rSPD, wl_step);

nets = cell(7, 1);
accuracy = zeros(7, 4);
neurons = zeros(7, 2);
best_n = zeros(7, 1);

for i = 5 : 5   
    close all
    switch i
        case 1
            [nt, acc, n, b] = create_ROC_patternet_1(input, targets, hn_min, hn_max, hn_step, trains);
        case 2
            [nt, acc, n, b] = create_ROC_patternet_2(input, targets, hn_min, hn_max, hn_step, trains, hn_min2, hn_max2, hn_step2);
        case 3
            [nt, acc, n, b] = create_ROC_fitnet_1(input, targets, hn_min, hn_max, hn_step, trains);
        case 4
            [nt, acc, n, b] = create_ROC_fitnet_2(input, targets, hn_min, hn_max, hn_step, trains, hn_min2, hn_max2, hn_step2);
        case 5
            [nt, acc, n, b] = create_ROC_newrb(input, targets, hn_min, hn_max, hn_step);
        case 6
            [nt, acc, n, b]  = create_ROC_newrbe_1(input, targets, hn_min, hn_max, hn_step, trains);
        case 7
            [nt, acc, n, b]  = create_ROC_newrbe_2(input, targets, hn_min, hn_max, hn_step, trains);
    end
  
    fileID = fopen(strcat('./files/CI_nn',num2str(i),'.txt'),'wt');
    fprintf(fileID,strcat('NN CREATED N. ', num2str(i), '\n'));
    if(i == 2 || i == 4)
        formatSpec = 'NEURONS1 = %d \t\t NEURONS1 = %d \t\t ACCURACY_1 = %f \t ACCURACY_2 = %f \t ACCURACY_3 = %f \t ACCURACY_OVERALL = %f\n';
        fprintf(fileID,formatSpec, [n(:,1)'; n(:,2)'; acc(:,1)'; acc(:,2)'; acc(:,3)'; acc(:,4)']);
        fprintf(fileID,'ROC ANALYSIS SOLUTION:\t\t NEURONS_1 = %d \t\t NEURONS_2 = %d \t\t ACCURACY = %f\n', n(b, 1), n(b, 2), acc(b,4));
        neurons = [n(b, 1) n(b, 2)];
    else
        formatSpec = 'NEURONS = %d \t\t ACCURACY_1 = %f \t ACCURACY_2 = %f \t ACCURACY_3 = %f \t ACCURACY_OVERALL = %f\n';
        fprintf(fileID,formatSpec, [n'; acc(:,1)'; acc(:,2)'; acc(:,3)'; acc(:,4)']);
        fprintf(fileID, 'ROC ANALYSIS SOLUTION:\t\t NEURONS = %d \t\t ACCURACY = %f\n\n\n', n(b), acc(b, 4));
        neurons = n(b, 1);
    end
    nets{i} = nt;
    accuracy(i,:) = acc(b,:);
    best_n(i) = b;
    save(strcat('./workspace/CI_nn',num2str(i)),'nt');
    fclose(fileID);

    figs = findobj('Type', 'figure');
    figs_number = [figs(:).Number];

    index = find(figs_number == 1);
    saveas(figs(index), strcat('./figures/CI_nn',num2str(i),'_confusion_matrix.png'));
    close(figs(index));

    index = find(figs_number == 2);
    saveas(figs(index), strcat('./figures/CI_nn',num2str(i),'_roc_curves.png'));
    close(figs(index));

    index = find(figs_number == 3);
    saveas(figs(index), strcat('./figures/CI_nn',num2str(i),'_performances.png'));
    close(figs(index));
end

%% Compute the best net according to the fuzzy system
    
fuzzy_evaluation = evalin('base','fuzzy_evaluation');
fuzzy_eval = zeros(size(accuracy,1),1);
for i = 1 : size(fuzzy_eval, 1)
    fuzzy_eval(i) = evalfis(accuracy(i,1:3),fuzzy_evaluation);
end

%% Compute the best # of neurons minimizing error and maximing precision

best = find(accuracy(:,2) == max(accuracy(fuzzy_eval == max(fuzzy_eval),2)), 1);

fprintf('The best network is %d\n', best);

net = nets{best};

save('./workspace/CI_best_nn','net');
