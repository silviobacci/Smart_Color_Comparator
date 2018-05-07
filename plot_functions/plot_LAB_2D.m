% ----------------------------------------------------------------------------------
% plot_LAB plots the LAB space and the specified LAB points in the sapce
% itself. If needed it can plot 2 LAB spaces.
% ----------------------------------------------------------------------------------
function plot_LAB_2D(LAB, RGB, centres)
    figure;
    
    subplot(1,2,1);
    scatter(LAB(2,:), LAB(3,:), [], RGB', 'filled');
    subplot(1,2,2);
    scatter(LAB(2,:), LAB(3,:), [], [0.7 0.7 0.7], 'filled');
    hold on;
    scatter(centres(:,1), centres(:,2), [], 'r', 'filled');
    hold off;
end