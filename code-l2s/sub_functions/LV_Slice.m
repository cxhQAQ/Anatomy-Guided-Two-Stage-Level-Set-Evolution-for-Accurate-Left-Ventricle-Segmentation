load ACDC

%% 
if (isfield(str,'testName'))
    str.groundTruth    = ACDC(str.testName).groundTruth;
    str.phi0           = ACDC(str.testName).phi0;
    str.Img            = double(im2gray(ACDC(str.testName).Img))+1;
    str.prior            = ACDC(str.testName).prior;
    
else
    error('没有输入数组')
end
