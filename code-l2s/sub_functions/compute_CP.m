% name:                 compute_CP
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
function [strmodel, strparam] = compute_CP(str, param)
%% 变量定义区
Img = str.Img;
groundTruth = str.groundTruth;
phi = mask2phi(str.phi0);


max_its = str.max_its;
numIter = str.numIter;
mu = str.mu;
epsilon  = str.epsilon ;
alpha = str.alpha;
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
    [str.vx, str.vy]=gradient(str.g);
    [str.Nx, str.Ny] = normalized_gradient(phi);
    str.k = div(str.Nx, str.Ny);
    str.k2 = curvature_central(str.Img);
    str.DrcU = Dirac(phi,epsilon);
    
    % compute average curvature
    s = gradnorm_phi(phi);
    str.average_c1 = sum(sum(str.k.*str.DrcU.*s))/sum(sum(str.DrcU.*s));
    
    % sign indicator
    str.signum = str.k >= 0;
    

        str.sub_c = str.k - str.average_c1 ;
        str.sub_c(str.sub_c>=0) = 0;
        C = str.beta .* str.sub_c .* str.DrcU;


    % convexity preserving compute phi
    A = C;
    L = Length(phi, str, param);
    P = Penalized(phi, str, param);
    phi = Numerical(phi, A, L, P, str, param);
    

      
%% 收敛测试&图形显示
    new_mask = phi<=0;
    c = convergence(prev_mask,new_mask,thresh,c);
    phishow(phi, its, str, param);
    if c <= 20
        its = its + 1;
        prev_mask = new_mask;
    else
        stop = 1;
    end
end

close all
% figure(21),imagesc(str.g),colormap(gray);
% figure(30),mesh(phi);
% figure(str.testName),imagesc(str.Img/255);
% colormap(gray),hold on;axis off;
% contour(phi,[0 0],'b','LineWidth',1);
% contour(groundTruth,[0 1],'r','LineWidth',1);
% contour(phi-str.klevel.k,[0 0],'g','LineWidth',1);
% contour(str.phi0,[0 1],'g','LineWidth',1);
% contour(groundTruth,[0 1],'r','LineWidth',2);
%     iterNum=[num2str(its), ' iterations'];  
%     title(iterNum);hold off; 
% figure,imshow(phi<0)
%% 验证性结构体
strmodel.str = str;
strmodel.g = str.g;
% strmodel.average_c1 = str.average_c1;
% strmodel.average_c2 = str.average_c2;
strmodel.times = toc;
strmodel.its = its;
strmodel.phi = phi;
% strmodel.dice = lsdice(phi, prior, str);

