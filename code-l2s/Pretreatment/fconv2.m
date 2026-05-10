function [F1, F2] = fconv2(mat1, mat2, mat3, mat4, mat5)
%快速卷积，根据输入个数判断卷积类型
%支持对第一个多层数组的逐层卷积
%两个二维实矩阵（第一个可以是多层），一个卷积核，一个复矩阵，一个fft长度
%% 变量分配
switch nargin
    case 5
        f1 = mat1;
        f2 = mat2;
        K  = mat3;
        fk = mat4;
        length = mat5;
        methon = 'conv2_2';
        type = 25;
    case 4
        f1 = mat1;
        K  = mat2;
        fk = mat3;
        length = mat4;
        methon = 'conv2_1';
        type = 25;
end

    Length = size(f1(:,:,1));
    d = ceil((size(K,1)-1)/2);
%% 分类计算
for i=1:size(f1,3)
switch methon
    case 'conv2_1'
        if size(K,1) < type
            F1(:,:,i) = conv2( f1(:,:,i), K, 'same' );
        else
            f1(length(1), length(2), :) = 0;
            F(:,:,i) = ifft2( fft2( f1(:,:,i)).*fk  );
            F1(:,:,i) = F(d+1:d+Length(1), d+1:d+Length(2), i);
        end
    case 'conv2_2'
        if size(K,1) < type
            F1(:,:,i) = conv2( f1(:,:,i), K, 'same' );
            F2(:,:,i) = conv2( f2(:,:,i), K, 'same' );
        else
            f1(length(1), length(2), :) = 0;
            f2(length(1), length(2), :) = 0;
            FA1(:,:,i) = ifft2( fft2( f1(:,:,i)).*fk  );
            FA2(:,:,i) = ifft2( fft2( f2(:,:,i)).*fk  );
            
            F1(:,:,i) = FA1(d+1:d+Length(1), d+1:d+Length(2), i);
            F2(:,:,i) = FA2(d+1:d+Length(1), d+1:d+Length(2), i);
        end
end
end
