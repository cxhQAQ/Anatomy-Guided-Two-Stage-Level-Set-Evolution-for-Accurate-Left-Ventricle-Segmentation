function b = Bias0_L2S(B, Img)
a = ones(size(B,2),1);
b0 = B*a;
b = reshape(b0,size(Img));
end

