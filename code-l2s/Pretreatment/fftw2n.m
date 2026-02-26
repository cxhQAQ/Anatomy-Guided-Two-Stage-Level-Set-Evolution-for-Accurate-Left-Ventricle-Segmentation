function N = fftw2n(Img, sigma, multiscale, methon)
%给定图像和卷积核参数，返还当前大小的最优化卷积
%暂定4n法,确定cpu浮点效率后重新修改
if ~exist('methon','var')
    error('fftw2n数组缺失')
end

switch multiscale{1}
    case 'Multi'
        K = 4.*(sigma + multiscale{2}.* ( multiscale{3}- 1 ) ) + 1;
    case 'single'
        K = 4.*sigma + 1;
end

[x1,y1,z1]=size(Img);
N1=x1 + K - 1;
N2=y1 + K - 1;

switch methon
    case '4n'
    N = [N1 + ( 4 - mod(N1,4) );  N2 + ( 4 - mod(N2,4) )];
end
end