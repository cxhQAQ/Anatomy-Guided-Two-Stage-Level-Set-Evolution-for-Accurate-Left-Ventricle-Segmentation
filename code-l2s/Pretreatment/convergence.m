function c = convergence(p_mask,new_mask,thresh,c)
% 收敛条件
% switch param.Length
    diff = p_mask - new_mask;
    n_diff = sum(abs(diff(:)))/sum(p_mask(:));
    if n_diff < thresh
        c = c + 1;
    else
        c = 0;
    end

