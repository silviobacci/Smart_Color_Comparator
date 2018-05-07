% ----------------------------------------------------------------------------------
% rc2spd converts the reflectance curve into the SPD applying the illuminant D65
% ----------------------------------------------------------------------------------
function spd = rc2spd(rc)
    f_range = 81:501;

    [~, spd_light] = illuminant('D65');
    spd_light = spd_light(f_range);
    
    spd = rc .* spd_light;
end