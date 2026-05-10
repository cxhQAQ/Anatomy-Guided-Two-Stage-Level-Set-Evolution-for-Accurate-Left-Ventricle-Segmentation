function s = gradnorm_phi(phi)
% 计算梯度范数
    [phi_x,phi_y] = gradient(phi);
    s = sqrt(phi_x.^2 + phi_y.^2);
end