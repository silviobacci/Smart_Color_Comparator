% ----------------------------------------------------------------------------------
% spd2xyz converts the spd of a color into xyz coordinates by performing
% the integral operation between the spd and the color matching function
% ----------------------------------------------------------------------------------

function XYZ = spd2xyz(spd)
    f_range = 21:441;

    % Take the color matching function
    [~, x_bar, y_bar, z_bar] = colorMatchFcn('1931_FULL');
    x_bar = x_bar(f_range)';
    y_bar = y_bar(f_range)';
    z_bar = z_bar(f_range)';
    
    f_range = 81:501;

    [~, spd_light] = illuminant('D65');
    spd_light = spd_light(f_range);
    
    % Normalization factor
    k = sum(y_bar .* spd_light);
    
    % Approximate the intregral operation with a sum
    X = sum(spd .* x_bar);
    Y = sum(spd .* y_bar);
    Z = sum(spd .* z_bar);
    XYZ = [X Y Z] ./ k;
end