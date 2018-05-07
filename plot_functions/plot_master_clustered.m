% ----------------------------------------------------------------------------------
% plot_master_clustered plots all the masters for each cluster in a
% different figure
% ----------------------------------------------------------------------------------

function plot_master_clustered(master_coordinates)
    id = evalin('base','id');
    for i = 1 : max(id)
        tmp = master_coordinates(:,id == i)';
        tmp = sortrows(tmp, 7);
        plot_patch(tmp(:,4:6)');
    end
end