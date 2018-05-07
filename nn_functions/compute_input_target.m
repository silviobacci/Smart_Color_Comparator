function [input, targets] = compute_input_target(master_rSPD, copy_rSPD, wl_step)
    master_copied = evalin('base', 'master_copied');
    copy_eval = evalin('base', 'copy_eval');
    copy_eval = copy_eval(master_copied, :);
    copy_eval = copy_eval(copy_eval(:,1) > 0, :);
    
    master_number = size(copy_rSPD,3);
    copy_number = size(copy_rSPD,2);
    input_size = 2 * size(under_sampling(master_rSPD(:,1),wl_step),1);
    n_classes = 3;
    
    ONE = [1; zeros(n_classes-1, 1)];
    TWO = [0; ones(n_classes-2, 1); 0];
    THREE = [zeros(n_classes-1, 1); 1];
    
    t = zeros(n_classes, copy_number, master_number);
    
    for i = 1 : master_number
        for j = 1 : copy_number
            if(copy_eval(i,j) == 1)
                t(:,j,i) = ONE;
            elseif(copy_eval(i,j) == 2)
                t(:,j,i) = TWO;
            else
                t(:,j,i) = THREE;
            end
        end
    end
    
    input = zeros(master_number * copy_number, input_size);
    targets = zeros(master_number*copy_number, n_classes);

    for i = 1 : master_number * copy_number
        if mod(i-1, copy_number) == 0
            index = (i - 1)/copy_number + 1;
            index_copy = 1;
        else
            index_copy = index_copy + 1;
        end
        
        master_tmp = under_sampling(master_rSPD(:,master_copied(index)),wl_step)';
        copy_tmp = under_sampling(copy_rSPD(:,index_copy,index),wl_step)';
        
        input(i,:) = [master_tmp copy_tmp];
        targets(i,:) = t(:,index_copy, index)';
    end
end