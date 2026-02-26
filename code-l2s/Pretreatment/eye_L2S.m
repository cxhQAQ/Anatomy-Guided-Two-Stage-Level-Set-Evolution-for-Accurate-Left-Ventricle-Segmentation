function A = eye_L2S(B)

A1 = B'; 
A2 = A1.*(repmat(ones(size(B(:,1)))',size(A1,1),1));   % A1, with each row multiplied with hphi
A = A1*A2';

end

