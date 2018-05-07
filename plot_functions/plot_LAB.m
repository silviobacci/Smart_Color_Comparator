% ----------------------------------------------------------------------------------
% plot_LAB plots the LAB space and the specified LAB points in the sapce
% itself. If needed it can plot 2 LAB spaces.
% ----------------------------------------------------------------------------------
function plot_LAB(LAB, RGB, LAB2, RGB2)
    figure;
    % Create a sphere with the proper size
    [X, Y, Z] = sphere();
    X = X .* 100;
    Y = Y .* 100;
    Z = Z .* 50 + 50;
        
    % Plot the spheres
    if exist('LAB2','var') && exist('RGB2','var')
        subplot(1,2,1);
    end
    
    plot3(X, Y, Z, 'Color', [0.5 0.5 0.5]);
    hold on;
    scatter3(LAB(2,:), LAB(3,:), LAB(1,:), [], RGB', 'filled');
    
    if exist('LAB2','var') && exist('RGB2','var')
        subplot(1,2,2);
        plot3(X, Y, Z, 'Color', [0.5 0.5 0.5]);
        hold on;
        scatter3(LAB2(2,:), LAB2(3,:), LAB2(1,:), [], RGB2', 'filled');
    end
end