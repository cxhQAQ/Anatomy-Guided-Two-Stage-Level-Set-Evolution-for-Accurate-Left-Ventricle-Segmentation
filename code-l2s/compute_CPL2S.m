% name:                 compute_CPL2S
% author:               xianhuang Cui
% creation:             2019/9/10
% modification:         2021/9/27   代码重构
% explan: 该函数的作用是水平集函数循环体&收敛测试，顺序执行{结构体验证&分配} {演化函数计算} ...
...{弧长项计算} {规则化项} {数值差分} {向前迭代} {收敛测试}...
    ...此函数的输入已经经过分类，直接指向特定算法，输出的验证性信息亦是对应特定算法
    ...所有代码段落使用%——分隔并提供修改说明...
    ...所有函数文件应当将性质稳定的变量集成为第一个结构体作为输入或输出
    ...将开发性质的变量集成为第二个结构体输入或输出
    % input: {变量结构体}一般变量的组合 ...
...{模型结构体}包含模型的[演化函数 弧长项 规则化项 数值求解]，使用名称—值对规范化...
    % output: {必要型结构体}包含[分割结果 相似系数 运行计时]等指标...
...{验证性结构体}验证性结构用于调参或分析特定模块作用，未指明时为空
    % naming convention: 所有的常量首字母大写，计算变量首字母小写，结构体分逻辑型和数值型命名
function [strmodel, strparam] = compute_CPL2S(str, param)
%% 变量定义区
Img = str.Img;
groundTruth = str.groundTruth;
phi = mask2phi(str.phi0);

max_its = str.max_its;
numIter = str.numIter;
timestep = str.timestep;
epsilon  = str.epsilon ;
thresh = param.Test.converge{2};

strparam = struct();

%循环变量
its = 0;      stop = 0;
prev_mask = phi;        c = 0;
tic

%% 组合模型
while ((its < max_its) && ~stop)  
    % compute curvatur
    phi = NeumannBoundCond(phi);
    [str.Nx, str.Ny] = normalized_gradient(phi);
    str.k = div(str.Nx, str.Ny);
    str.DrcU = Dirac(phi,epsilon);
    
    % compute dataForce
    [dataForce, output2, str.b] = dataForce_CPL2S(phi, str, param);
    
    % compute phi
    Force = -str.DrcU .* sum(dataForce,3);
    L = Length(phi, str, param);
    P = Penalized(phi, str, param);
    phi = Numerical(phi, Force, L, P, str, param);
    
%% 收敛测试&图形显示
    new_mask = phi<=0;
    c = convergence(prev_mask,new_mask,thresh,c);
    phishow(phi, its, str, param);
    if c <= 10
        its = its + 1;
        prev_mask = new_mask;
    elseif (c > 10) && (its > 100)
        stop = 1;
    end
end

% close all

figure(str.testName),imshow(str.Img/255);
colormap(gray),hold on;axis off;
contour(phi,[0 0],'r','LineWidth',1);
% contour(groundTruth,[0 1],'r','LineWidth',2);
% contour(str.phi0,[0 1],'g','LineWidth',1);
% contour(phi,[0 1],'g','LineWidth',2);
%     iterNum=[num2str(its), ' iterations'];  
%     title(iterNum);hold off; 
% figure,imshow(phi<0)
%% 验证性结构体
strmodel.str = str;
strmodel.times = toc;
strmodel.its = its;
strmodel.phi = phi;
% strmodel.dice = lsdice(phi, prior, str);
strmodel.output2 = output2;
strmodel.b = str.b;

strparam.lambda1 = str.lambda1;
strparam.n_poly = str.n_poly;
strparam.max_its = str.max_its;

