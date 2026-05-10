function [c1,c2,b]=L2S(Img, phi, A, B, b, lambda_l2)



II = eye(size(B,2),size(B,2));
h_phi = Heaviside(phi,2);
A1 = B';

c1 = sum((Img-b).*h_phi,'all')/sum(h_phi,'all');
c2 = sum((Img-b).*(1-h_phi),'all')/sum(1-h_phi,'all');
c = c1*h_phi + c2*(1-h_phi);

% A2 = A1.*(repmat(ones(size(h_phi(:)))',size(A1,1),1));   % A1, with each row multiplied with hphi
% A = A1*A2';

% 这里是A的估计
a = (A + lambda_l2*II)\(A1*(Img(:)-c(:)));

% 这里是灰度不均匀场b的估计和转置，下方h_phi可有可无
p1_vec = B*a;
b = reshape(p1_vec,size(Img));

% curvature   = curvature_central(phi);
% delta_phi   = Dirac_global(phi,2);
% 
% evolve_force = delta_phi.*(-l1*(u-c1-b).^2 + l2*(u-c2-b).^2);
% 
% dphi_dt = evolve_force./(max(abs(evolve_force(:)))+eps);
% delta_t = .8/(max(abs(dphi_dt(:)))+eps);          % Step size using CFL
% 
% phi = phi + delta_t*dphi_dt;

end