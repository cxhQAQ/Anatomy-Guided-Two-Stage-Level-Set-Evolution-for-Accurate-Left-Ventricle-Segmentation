% name:                 compute_model
% author:               xianhuang Cui
% creation:             2019/9/10
% modification:         2021/9/27   代码重构
% explan: 该函数的作用是水平集方法计算主体，顺序执行{结构体验证} {模型函数组合&参数分配} ...
           ...{循环体收敛测试}
           ...所有代码段落使用%——分隔...
           ...所有函数文件应当将性质稳定的变量集成为第一个结构体作为输入或输出
                ...将开发性质的变量集成为第二个结构体输入或输出
% input: {变量结构体}全部一般变量的组合 ...
        ...{模型结构体}包含模型的[演化函数 弧长项 规则化项 数值求解]，使用名称—值对规范化
% output: {必要型结构体}包含[分割结果 相似系数 运行计时]等指标...
        ...{验证性结构体}验证特定结构是否有效时加入
% naming convention: 所有的常量首字母大写，计算变量首字母小写，结构体分逻辑型和数值型命名
%% 
function [strmodel , strparam] = compute_model(str , param)

switch param.methon
    case 'TEST'
        [strmodel, strparam] = compute_phi(str, param);
    case 'lsm_cv'
        [strmodel, strparam] = lsm_cv(str, param);
    case 'cv_4PHD'
        [strmodel, strparam] = compute_cv_4PHD(str, param);
    case 'RSF_Initialize'
        [strmodel, strparam] = RSF_Initialize(str, param);
    case 'lsm_lbf'
        [strmodel, strparam] = lsm_lbf(str, param);
    case 'lsm_lpf'
        [strmodel, strparam] = lsm_lpf(str, param);
    case 'lsm_osf'
        [strmodel, strparam] = lsm_osf(str, param);
    case 'lsm_le'
        [strmodel, strparam] = lsm_le(str, param);
    case 'lsm_RV'
        [strmodel, strparam] = compute_RVLSM(str, param);
    case 'DRLSE'
        [strmodel, strparam] = compute_DRLSE(str, param);
    case 'lsm_lif'
        [strmodel, strparam] = lsm_lif(str, param);
    case 'lsm_RESLS'
        [strmodel, strparam] = compute_RESLS(str, param);
    case 'lsm_REL2S'
        [strmodel, strparam] = compute_REL2S(str, param); 
    case 'lsm_LIC'
        [strmodel, strparam] = compute_LIC(str, param);
    case 'lsm_LATE'
        [strmodel, strparam] = compute_LATE(str, param);
    case 'lsm_LSACM'
        [strmodel, strparam] = compute_LSACM(str, param); 
    case 'lsm_L0MS'
        [strmodel, strparam] = compute_L0MS(str, param); 
    case 'REL2S_4PHD'
        [strmodel, strparam] = compute_REL2S_4PHD(str, param); 
    case 'REL2S_3PHD'
        [strmodel, strparam] = compute_REL2S_3PHD(str, param);
    case 'lbf_4PHD'
        [strmodel, strparam] = compute_lbf_4PHD(str, param);
    case 'lic_4PHD'
        [strmodel, strparam] = compute_lic_4PHD(str, param); 
    case 'LATE_4PHD'
        [strmodel, strparam] = compute_LATE_4PHD(str, param); 
    case 'lsm_REALF'
        [strmodel, strparam] = compute_REALF(str, param); 
    case 'lsm_ALVLS'
        [strmodel, strparam] = compute_ALVLS(str, param); 
    case 'CCAC_DRLSE'
        [strmodel, strparam] = compute_CCAC_DRLSE(str, param); 
    case 'CCAC_RSF'
        [strmodel, strparam] = CCAC_RSF(str, param); 
    case 'CPLS_DRLSE'
        [strmodel, strparam] = compute_CPLS_DRLSE(str, param); 
    case 'L2S_Initialize'
        [strmodel, strparam] = compute_CPL2S(str, param); 
    case 'CPLS'
        [strmodel, strparam] = compute_CP(str, param); 
    case 'Ablation_RSF'
        [strmodel, strparam] = compute_Ablation_RSF(str, param);
end