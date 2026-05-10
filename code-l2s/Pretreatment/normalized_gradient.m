function [Nx, Ny] = normalized_gradient(phi)
% 计算归一化梯度
    [phi_x,phi_y] = gradient(phi);
    s = sqrt(phi_x.^2 + phi_y.^2);
    smallNumber = 1e-10;  
    Nx = phi_x./(s+smallNumber); % add a small positive number to avoid division by zero
    Ny = phi_y./(s+smallNumber);
end

