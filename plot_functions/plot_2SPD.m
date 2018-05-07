% ----------------------------------------------------------------------------------
% plot_2SPD plots 2 SPD in the same figure
% ----------------------------------------------------------------------------------
function plot_2SPD(wl, spd1, spd2)
    y_axis = [380 800 min(min(spd1),min(spd2)) max(max(spd1),max(spd2))];
    
    figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(1,2,1);
    plot_SPD(wl, spd1, y_axis);
    subplot(1,2,2);
    plot_SPD(wl, spd2, y_axis);
end