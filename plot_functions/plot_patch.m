% ----------------------------------------------------------------------------------
% plot_patch plots all the specified RGB patches.
% ----------------------------------------------------------------------------------
function plot_patch(RGB, dim)
    if ~exist('dim','var')
        dim = min(size(RGB,2),28);
    end
    % fig = figure('Units','pixels','Position',[440 378 700 700]);
    fig = figure('Units','normalized','Position',[0.3 0.2 0.4 0.5],'Resize','on');
    axes('xcolor', get(fig, 'Color'), 'ycolor', get(fig, 'Color'));
    % f_pos = get(fig,'Position');
    f_pos = getpixelposition(fig);
            
    n_rows = ceil(size(RGB,2) / dim);
    n_cols = dim;
    
    if max(n_rows, n_cols) == n_rows
        height = f_pos(4) - f_pos(4)/10;
        width = height * n_cols / n_rows;
    else
        width = f_pos(3) - f_pos(3)/10;
        height = width * n_rows / n_cols;
    end
    
    bottom = f_pos(4)/2 - height/2;
    left = f_pos(3)/2 - width/2;
    
    bottom = bottom / f_pos(4); 
    left = left / f_pos(3);
    width = width / f_pos(3);
    height = height / f_pos(4);
    
    pos = [left bottom width height];
    
    hold on;
    yc = 0;
    xc = 1;
    axis([0 n_cols 0 n_rows]);
    for i = 1 : size(RGB,2)
        if any(RGB(:,i) < 0) || any(RGB(:,i) > 1)
            fprintf('NEGATIVE RGB VALUE IN COLOR %f:  \n', i, RGB(:,i)');
        else
            x = [xc-1 xc xc xc-1];
            y = [yc yc yc+1 yc+1];
            patch(x, y, RGB(:,i)');
            gca.ActivePositionProperty = 'position';
            c = get(fig,'Children');
            set(c, 'Units', 'normalized' ,'Position', pos);
        end
        if (mod(i,dim) == 0)
            xc = 0;
            yc = yc+1;
        end
        xc = xc+1;
    end
    hold off;
end
   