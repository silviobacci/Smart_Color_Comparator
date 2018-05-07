% ----------------------------------------------------------------------------------
% plot_master_clustered plots all the masters (with the related copies) for each 
% cluster in a different figure
% ----------------------------------------------------------------------------------

function plot_master_copy_clustered(master_coordinates, copy_coordinates)
    id = evalin('base','id');
    master_copied = evalin('base','master_copied');
    for i = 1 : max(id)
        tmp = [];
        tmp_master = master_coordinates(:,id == i);
        [~, index] = intersect(master_copied, find(id == i), 'rows');
        tmp_coordinates = copy_coordinates(:, :, index);

        for j = 1 : size(tmp_master,2)
            tmp = [tmp tmp_coordinates(4:6, :, j) tmp_master(4:6, j)];
        end
        plot_patch(tmp, 4);
    end
end