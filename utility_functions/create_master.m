% ----------------------------------------------------------------------------------
% create_master takes the original masters, computes the coordinates and
% delete the masters whose RGB values were negative.
% ----------------------------------------------------------------------------------

function [master_spectra, master_rSPD, new_coordinates] = create_master(spectra, coordinates)
    wrong_master = 37;
    n_master = size(coordinates,2) - wrong_master;

    master_spectra = zeros(421,n_master);
    master_rSPD = zeros(421,n_master);
    new_coordinates = zeros(9,n_master);

    XYZ = zeros(size(coordinates,2), 3);
    RGB = zeros(size(coordinates,2), 3);
    LAB = zeros(size(coordinates,2), 3);
    
    n_wrong = 0;

    for i = 1 : size(coordinates, 2)
        rc = spectra(:,i);
        
        rSPD = rc2spd(rc);
        
        XYZ(i,:) = spd2xyz(rSPD);

        RGB(i,:) = xyz2rgb(XYZ(i,:));

        LAB(i,:) = xyz2lab(XYZ(i,:));

        if any(RGB(i,:) < 0) ~= 1
            new_coordinates(1:3,i - n_wrong) = XYZ(i,:);
            new_coordinates(4:6,i - n_wrong) = RGB(i,:);
            new_coordinates(7:9,i - n_wrong) = LAB(i,:);
            
            master_rSPD(:,i - n_wrong) = rSPD;
            
            master_spectra(:,i - n_wrong) = spectra(:,i);
        else
            n_wrong = n_wrong + 1;
        end
    end
end