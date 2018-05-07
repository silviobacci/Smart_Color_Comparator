% ----------------------------------------------------------------------------------
% undersampling computes the undersampling operation on the rSPD taking
% wavelengths with a specified step.
% ----------------------------------------------------------------------------------

function [sp] = under_sampling(og_sp, step)
    if size(og_sp,1) == 1
        og_sp = og_sp';
    end 
    
    sp = zeros(floor(size(og_sp,1)/step), 1);
    
    for i = 1: 1: size(og_sp,1)
        if(mod(i,step) == 0)
            sp(i/step) = og_sp(i);
        end
    end
end 