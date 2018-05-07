% ----------------------------------------------------------------------------------
% compute_deltaE computes the deltaE of 1976, 1994 and 2000
% ----------------------------------------------------------------------------------

function [e76, e94, e00] = compute_deltaE(master_lab, copies_lab)
    copies_number = size(copies_lab,2);
    e94 = zeros(copies_number,1);
    e76 = zeros(copies_number,1);
    e00 = zeros(copies_number,1);
    
    %computing
    for i = 1 : copies_number
        e76(i) = norm(master_lab - copies_lab(:,i));
        e94(i) = compute_deltaE_94(master_lab, copies_lab(:,i));
        e00(i) = compute_deltaE_00(master_lab, copies_lab(:,i));
    end
end