% ----------------------------------------------------------------------------------
% compute_deltaE computes the deltaE 2000
% ----------------------------------------------------------------------------------

function deltaE=compute_deltaE_00(master_lab, copies_lab)
    SamplesL1 = master_lab(1,1);
    SamplesL2 = copies_lab(1,1);
    Samplesa1 = master_lab(2,1);
    Samplesa2 = copies_lab(2,1);
    Samplesb1 = master_lab(3,1);
    Samplesb2 = copies_lab(3,1);

    SamplesC1 = sqrt(Samplesa1.^2+Samplesb1.^2);
    SamplesC2 = sqrt(Samplesa2.^2+Samplesb2.^2);
    deltaEab = sqrt((SamplesL1 - SamplesL2).^2 + (Samplesa1 - Samplesa2).^2 + (Samplesb1 - Samplesb2).^2);
    deltaCab = sqrt((Samplesa1 - Samplesa2).^2 + (Samplesb1 - Samplesb2).^2);
    deltaHab = sqrt(deltaEab.^2 - (SamplesL1-SamplesL2).^2 - deltaCab.^2);
    C_bar = (SamplesC1 + SamplesC2)/2;
    G = 0.5*(1-sqrt(C_bar.^7./(C_bar.^7+25^7)));

    Lsp = SamplesL1;
    Lbp = SamplesL2;
    asp = (1+G).*Samplesa1;
    abp = (1+G).*Samplesa2;
    bsp = Samplesb1;
    bbp = Samplesb2;
    Csp = sqrt(asp.^2+bsp.^2);
    Cbp = sqrt(abp.^2+bbp.^2);
    hsp = f_atan(asp,bsp);
    hbp = f_atan(abp,bbp);

    deltaLp = Lbp - Lsp;
    deltaCp = Cbp - Csp;
    deltahp = f_deltahp(hsp, hbp, Csp, Cbp);  
    deltaHp = 2*sqrt(Cbp.*Csp).*sin(deltahp/2);

    Lp_bar = (Lsp + Lbp)/2;
    Cp_bar = (Csp + Cbp)/2;
    hp_bar = hueDiff(hsp, hbp, Csp, Cbp);

    SL = 1 + (0.015*(Lp_bar-50).^2)./sqrt(20+(Lp_bar-50).^2);
    SC = 1 + 0.045*Cp_bar;
    T = 1 - 0.17*cos(hp_bar-pi/6) + 0.24*cos(2*hp_bar) + 0.32*cos(3*hp_bar+pi/30) - 0.20*cos(4*hp_bar-pi/(180/63));
    deltaTheta = (30*exp(-((hp_bar-pi/(180/275))/(25*pi/180)).^2))*pi/180;
    RC = 2*sqrt((Cp_bar.^7)./(Cp_bar.^7 + 25^7));
    RT = -sin(2*deltaTheta).*RC;
    SH = 1 + 0.015*Cp_bar.*T;

    deltaE = sqrt((deltaLp./SL).^2 + (deltaCp./SC).^2 + (deltaHp./SH).^2 + RT.*(deltaCp./SC).*(deltaHp./SH));
    
end
    

function y = f_atan(x1,x2)
for i = 1:size(x1,1)
    if x1(i)==x2(i)
        y(i,:) = 0;
    elseif x1(i)>=0 && x2(i)<0
        y(i,:) = atan(x2(i)/x1(i))+2*pi;
    elseif x1(i)<0
        y(i,:) = atan(x2(i)/x1(i))+pi;
    elseif x1(i)>=0 && x2(i)>0
        y(i,:) = atan(x2(i)/x1(i));
    end
end
end

function y = f_deltahp(x1,x2,x3,x4)
for i = 1:size(x1,1)
    if x3(i)+x4(i) == 0
        y(i,:) = 0;
    elseif abs(x2(i)-x1(i)) <= pi
        y(i,:) = x2(i)-x1(i);
    elseif x2(i)-x1(i)>pi
        y(i,:) = x2(i)-x1(i)-2*pi;
    elseif x2(i)-x1(i)<(-pi)
        y(i,:) = x2(i)-x1(i)+2*pi;
    end
end
end

function y = f(x)
if x>0.008856
    y = x.^(1/3);
else
    y = 7.787*x+16/116;
end
end

function y = hueDiff(x1, x2, x3, x4)
    for i = 1:size(x1,1)
        if x3(i)*x4(i) == 0
            y(i,:) = x1(i)+x2(i);
        elseif abs(x1(i)-x2(i)) <= pi
            y(i,:) = (x1(i)+x2(i))/2;
        elseif (abs(x1(i)-x2(i)) > pi) && ((x1(i)+x2(i)) < 2*pi)
            y(i,:) = (x1(i)+x2(i)+2*pi)/2;
        elseif (abs(x1(i)-x2(i)) > pi) && ((x1(i)+x2(i)) >= 2*pi)
            y(i,:) = (x1(i)+x2(i)-2*pi)/2;
        end
    end
end