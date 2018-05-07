% ----------------------------------------------------------------------------------
% compute_deltaE computes the deltaE of 1994
% ----------------------------------------------------------------------------------
function e94 = compute_deltaE_94(master_lab, copies_lab)
    k1= 0.045;
    k2 = 0.015; 
    kl = 1;
    kc = 1;
    kh = 1;
    
    deltaE = norm(master_lab - copies_lab);
    deltaL = master_lab(1) - copies_lab(1);
    c1 = sqrt(master_lab(2)^2 + master_lab(3)^2);
    c2 = sqrt(copies_lab(2)^2 + copies_lab(3)^2);
    deltaC = c1 - c2;
    deltaH = sqrt(deltaE^2 - deltaC^2 - deltaL^2);
    sl = 1;
    sc = 1 + k1 * c1;
    sh = 1 + k2 * c1;
    e94 = sqrt((deltaL / (kl * sl))^2 + (deltaC / (kc * sc))^2 + (deltaH / (kh * sh))^2);
end