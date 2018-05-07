% ----------------------------------------------------------------------------------
% plot_rpatch creates a figure with 2 squares and colors the right one.
% ----------------------------------------------------------------------------------
function plot_rpatch(RGB)
    if size(RGB, 2) == 1
        RGB = RGB';
    end
    axis([0 2 0 1]);
    if any(RGB < 0) || any(RGB > 1)
        fprintf('NEGATIVE RGB VALUE IN COLOR \n');
    else
        x = [1 2 2 1];
        y = [0 0 1 1];
        patch(x, y, RGB, 'LineStyle', 'none');
    end
end