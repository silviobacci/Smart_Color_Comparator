% ----------------------------------------------------------------------------------
% create_copy creates a copy of the master specifying both the wavelenght
% to perturb and the intensity of the noise to apply.
% ----------------------------------------------------------------------------------

function [copy_spectra, copy_rSPD, copy_coordinates] = create_copy(master_spectra, db, wl_noise, db2, wl_noise2)
    n_master = size(master_spectra,2);
    copy_coordinates = zeros(9,n_master);

    if size(master_spectra,1) == 1
        master_spectra = master_spectra';
    end
    
    % Firt portion to disturb
    portion_to_disturb = master_spectra(wl_noise - 379,1);
    
    % Perturbation with a gaussian white noise
    rng(1);
    portion_disturbed =  awgn(portion_to_disturb, db);
    
    master_spectra(wl_noise - 379,1) = portion_disturbed;
    
    % Optional second portion to disturb
    if ~exist('db2','var')
        db2 = db;
    end
    
    if exist('wl_noise2','var')
        portion_to_disturb = master_spectra(wl_noise2 - 379,1);
        portion_disturbed =  awgn(portion_to_disturb, db2);
        master_spectra(wl_noise2 - 379,1) = portion_disturbed;
    end
    
    copy_spectra = master_spectra; 
    copy_spectra(copy_spectra<0) = 0;
    
    % Compute all the coordinates of the copy
    
    copy_rSPD = rc2spd(copy_spectra);
        
    copy_coordinates(1:3,:) = spd2xyz(copy_rSPD);

    copy_coordinates(4:6,:) = xyz2rgb(copy_coordinates(1:3,:)');

    copy_coordinates(7:9,:) = xyz2lab(copy_coordinates(1:3,:)');
end