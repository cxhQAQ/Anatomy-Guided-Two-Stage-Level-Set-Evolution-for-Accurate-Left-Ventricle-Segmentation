function seg = Cardiac_Initialize_L2S(str)
%使用RSF模型对左心室预分割
%% 模型参数定义,{直接定义} {预计算定义}
%基本参数与运算模式
str.max_its   = 700;
str.numIter   = 10;
str.lambda1   = 0.004;
str.lambda2   = 0.004;
str.nu        = 0;
str.timestep  = .1;
str.mu        = 0.2;
str.epsilon   = 0.5;
str.sigma     = 3;

str.lambda_l2 = 0;
str.n_poly    = 4;

str.B         = LegendreBasis2D_vectorized(str.Img, str.n_poly);
str.A         = eye_L2S(str.B);
str.b         = Bias0_L2S(str.B, str.Img);

param=struct();
param.methon        = 'L2S_Initialize';
param.Fitting       = 'Chan';
param.Length        = 'Chan';
param.Penalized     = 'distReg';
param.Numerical     = 'Central';
param.Filter        = 'Gauss';
param.Multiscale    = {'single',4,1};
param.Pretreatment  = {'log'};
param.Test.phishow  = {'on',2,1};
param.Test.converge = {'entropy',1e-4};

if size(str.Img,3)==1
    param.Colormap  = 'gray';
    param.size3 = 1;
elseif size(str.Img,3)==3
    param.Colormap  = 'RGB';
    param.size3 = 3;
end

Multiscale


%% 模型计算
[strmodel , ~]=compute_model(str , param );
seg = strmodel.phi<0;
close



end

