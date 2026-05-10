% name:                 Hybrid_model_CP_L2S
% author:               xianhuang Cui
% creation:             2019/9/10
% modification:         2021/9/27   代码重构
% explan: 脚本模式为水平集方法运行示例，顺序执行{读取预处理} {结构化参数定义} ...
           ...{模型计算} {计时&绘图&分割评价}...
           ...所有代码段落使用%---分隔...
           ...所有函数文件应当将性质稳定的变量集成为第一个结构体作为输入或输出
                ...将开发性质的变量集成为第二个结构体输入或输出
% function pattern: 输出{水平集可调参数}，输出{用时&分割评价}，代码段开头增加参数验证
% naming convention: 所有的常量首字母大写，计算变量首字母小写，结构体分逻辑型和数值型命名

%% 读取预处理,{数据集[BSD500 灰度不均匀]} {提取单幅图像} {图像前处理}
str.testName= 1;
Total_LV

%% 模型参数定义,{直接定义} {预计算定义}
%基本参数与运算模式
str.max_its   = 400;
str.numIter   = 10;
str.lambda1   = 0;
str.timestep  = 1;
str.mu        = 0.2/str.timestep;            
str.epsilon   = 0.5;
str.g         = edge(str.Img, 'std');
str.beta      = 2;

param=struct();
param.methon        = 'CPLS';
param.Length        = 'distReg';
param.Penalized     = 'distReg';
param.Numerical     = 'convexity';
param.Test.phishow  = {'off',10,1};
param.Test.converge = {'entropy',1e-4};

if size(str.Img,3)==1
    param.Colormap  = 'gray';
    param.size3 = 1;
elseif size(str.Img,3)==3
    param.Colormap  = 'RGB';
    param.size3 = 3;
end


str.error = 0;
str.init = str.phi0;

if ~isfield(str, 'phi0')
    str.error = 1;    
else
    
str.L2S_init = Cardiac_Initialize_L2S(str);
str.phi0 = str.L2S_init;
end

%% 模型计算
[strmodel , strparam]=compute_model(str , param );
str.seg = strmodel.phi<0;
dice(str.label , str.groundTruth)
dice(str.seg, str.groundTruth)

str.label_hd = hausdorff_distance(str.label, str.groundTruth);
fprintf('Label Hausdorff distance = %.4f\n', str.label_hd);

str.seg_hd = hausdorff_distance(str.seg, str.groundTruth);
fprintf('Seg Hausdorff distance = %.4f\n', str.seg_hd);

