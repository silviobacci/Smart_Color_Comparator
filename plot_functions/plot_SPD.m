% ----------------------------------------------------------------------------------
% plot_SPD plots the SPD of a color
% ----------------------------------------------------------------------------------
function plot_SPD(wl, spd, y_axis)
    if size(wl,1) == 1
        wl = wl';
    end
    
    if size(spd,1) == 1
        spd = spd';
    end
    
    if size(spd,1) ~= size(wl,1)
        error('Array MUST be of the same size.');
    end
    
    if ~exist('y_axis','var')
        y_axis = [380 800 min(spd) max(spd)];
    end
    
    sRGB = spectrumRGB(wl);
    
    axis(y_axis);
    
    b = bar(wl', spd, 'hist' , 'LineStyle','none');
    set(b, 'CData', sRGB(1,:,:), 'CDataMapping', 'direct', 'EdgeColor', 'none');
end