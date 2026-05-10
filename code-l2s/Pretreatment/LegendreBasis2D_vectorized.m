function [B] = LegendreBasis2D_vectorized(Img,n_poly)

%LEGENDREBASIS compute K shifted legendre basis for the vectorized image

[Nr,Nc] = size(Img);
N = length(Img(:));     % Vectorized image

B = zeros(N,(n_poly+1).^2);
% orthonormal_B = B;

[B_r,B_r_ortho] = legendre_1D(Nr,n_poly);
[B_c,B_c_ortho] = legendre_1D(Nc,n_poly);

ind = 0;
for ii = 1 : n_poly+1
    for jj = 1 : n_poly+1
        ind = ind+1;
        row_basis = B_r(:,ii);
        col_basis = B_c(:,jj);
        outer_prod = row_basis*col_basis';  % same size as the image
        B(:,ind) = outer_prod(:);
        
    end
end


% orthonormal_B = [];
% B_2D          = [];

end

function [B,orthonormal_B] = legendre_1D(N,k)

X = -1:2/(N-1):1;
p0 = ones(1,N);


B = zeros(N,k+1);
orthonormal_B = B;
B(:,1) = p0';
orthonormal_B(:,1) = B(:,1)/norm(B(:,1));

for ii = 2 : k+1
    Pn = 0;
    n = ii-1;   % degree
    for k = 0 : n
       Pn = Pn +  (nchoosek(n,k)^2)*(((X-1).^(n-k)).*(X+1).^k);
    end
    B(:,ii) = Pn'/(2)^n;
    orthonormal_B(:,ii) = B(:,ii)/norm(B(:,ii));
end

end
