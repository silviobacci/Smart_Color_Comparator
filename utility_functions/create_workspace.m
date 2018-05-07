% ----------------------------------------------------------------------------------
% create_workspace creates the new masters, choosees a subset to disturb and 
% creates the copies 
% ----------------------------------------------------------------------------------

function create_workspace()
    %% Load master spectra, master coordinates and the neural network

    load CI_dataset.mat;

    %% Compute new spectra and coordinates eliminating wrong colors

    [master_spectra, master_rSPD, master_coordinates] = create_master(spectra, coordinates);
    
    
    %% Compute clusters of masters to copy
    
    dataset_portion = 0.4;
    [train_samples, test_samples, valid_samples, id, xb_index, centres] = find_master(master_coordinates(7:9,:), dataset_portion); 
    master_copied = [train_samples; test_samples; valid_samples];
    master_copied_number = size(master_copied, 1);
    

    %% Parameters of the script

    copy_number = 4;
    wl_number = 421;
    coordinates_number = 9;

    %% Variables definition

    copy_spectra = zeros(wl_number, copy_number, master_copied_number);
    copy_rSPD = zeros(wl_number, copy_number, master_copied_number);
    copy_coordinates = zeros(coordinates_number, copy_number, master_copied_number);

    e76 = zeros(master_copied_number, copy_number);
    e94 = zeros(master_copied_number, copy_number);
    e00 = zeros(master_copied_number, copy_number);

    %% Create the waitbars

    h1 = waitbar(0,{'Generating Copies... (0%)'},'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(h1,'canceling',0);

    h2 = waitbar(0,{'Generating Copy 1... (0%)'},'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(h2,'canceling',0);
    set(h2, 'position', [540 411-78 360 78], 'doublebuffer', 'on');

    for i = 1 : size(master_copied)
        [copy_spectra(:, :, i), copy_rSPD(:, :, i), copy_coordinates(:, :, i)] = generate_copies(master_spectra(:, master_copied(i)), h2, i);

        [e76(i,:), e94(i,:), e00(i,:)] = compute_deltaE(master_coordinates(7:9,master_copied(i)), copy_coordinates(7:9,:,i));
        
        percent = i/master_copied_number;
        waitbar(percent, h1, strcat({'Generating Copies... ('},num2str(floor(percent*100)),{' %)'}));

        if getappdata(h2,'canceling')
            delete(h2);
            break;
        end

        if getappdata(h1,'canceling')
            delete(h1);
            break;
        end
    end

    delete(h1);
    delete(h2);

    %% Clear all the local variables

    clear coordinates_number copy_number h1 h2 i index m_max m_min m_step master_copied_number percent wl_number dataset_portion;

    save('./workspace/CI_dataset_new.mat');
end