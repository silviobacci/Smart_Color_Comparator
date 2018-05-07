% ----------------------------------------------------------------------------------
% generate_copies creates all the copies for a master chaning the intensity
% of the noise applied.
% ----------------------------------------------------------------------------------

function [copy_spectra, copy_rSPD, copy_coordinates] = generate_copies(master, h, index_master)
    wl = 380:800;
    wl_size = size(wl,2) - 1;
    
    step_v = 420;
    min_v = wl(1);
    max_v = wl(size(wl,2)) - step_v;
    
    low_db = 15;
    up_db = 45;
    step_db = 10;
    
    copies_number = (wl_size / step_v) * ((up_db - low_db)/step_db +1);
    copy_spectra = zeros(size(wl,2),  copies_number);
    copy_rSPD = zeros(size(wl,2),  copies_number);
    copy_coordinates = zeros(9,  copies_number);
    
    index = 1;
    for i = min_v : step_v : max_v
        for j = low_db : step_db : up_db
            [copy_spectra(:, index), copy_rSPD(:,index), copy_coordinates(:, index)] = create_copy(master, j, i:i+step_v);
            index = index + 1; 
        end
 
        if exist('h','var')
            % Update the waitbar
            percent = (index - 1) / ((max_v - min_v + step_v)/step_v * (up_db - low_db + step_db)/step_db);
            waitbar(percent, h, strcat({'Generating Copy '},num2str(index_master),{'... ('},num2str(floor(percent*100)),{' %)'}));
        end
    end
end