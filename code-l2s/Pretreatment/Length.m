function [L, phi] = Length(phi, str, param)
% 长度项
L = 0;
switch param.Length
    case 'Chan'
    nu = str.nu;
    DrcU = str.DrcU;
    k = str.k;
    L = nu.*DrcU.*k;
    
    case 'Zhang'
%     K = str.Ksigma{1};
%     KONE = str.KONE{1};
%     phi = conv2(phi, K, 'same')./KONE;
    delt2 = str.delt2;
    phi = phi + delt2*4*del2(phi);

    
    case 'distReg'
    lambda1 = str.lambda1;
    DrcU = str.DrcU; 
    k = str.k;
    vx = str.vx;
    vy = str.vy;
    Nx = str.Nx;
    Ny = str.Ny;
    g = str.g;
    
    L = ( DrcU.*(vx.*Nx+vy.*Ny) + DrcU.*g.*k )*lambda1;
    
    case 'RESLS'
    lambda1 = str.lambda1;
    K = str.K;
    
    DrcU = str.DrcU; 
    k = str.k;
    vx = str.vx;
    vy = str.vy;
    Nx = str.Nx;
    Ny = str.Ny;
    g = str.g;
    
    L = ( DrcU.*(vx.*Nx+vy.*Ny) + DrcU.*g.*k )*lambda1 + DrcU.*k.*K;
    
    case 'ALF'
    % v1 = K;
    k3 = str.k3;
    v1 = str.v1;
    
    DrcU = str.DrcU; 
    k = str.k;
    vx = str.vx;
    vy = str.vy;
    Nx = str.Nx;
    Ny = str.Ny;
    g = str.g;
    
    L = DrcU.*k3.*( vx.*Nx+vy.*Ny + g.*k ) + DrcU.*k.*v1;
end
end