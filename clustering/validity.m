% ----------------------------------------------------------------------------------
% validity computes the Xie-Beni index of a cluster
% ----------------------------------------------------------------------------------

function xb_index = validity(data, id, c)
    N = size(data,1);
    k = size(c,1);
    compactness = 0;
    separation = inf;
    for i = 1 : k
        compactness = compactness + norm(data(id == i, :) - c(i,:))^2;
        if(i ~= k)
            separation = min(separation, norm(c(i)-c(k))^2);
        end
    end 
    xb_index = compactness / (separation * N);
end