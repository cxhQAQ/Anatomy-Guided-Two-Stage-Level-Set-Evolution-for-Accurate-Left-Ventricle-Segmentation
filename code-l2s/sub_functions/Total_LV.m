load Total_LV

i = str.testName;
str.groundTruth = Total_LV(i).groundTruth;
str.Img = Total_LV(i).Img;
str.phi0 = Total_LV(i).phi0;
str.label = Total_LV(i).label;


    % 处理 str.label 的最大连通区域并与 phi0 对比
    % 对 label 进行连通区域分解
    cc_label = bwconncomp(str.label);
    if cc_label.NumObjects > 0
        % 计算每个分量的像素数，取最大者
        numPix_label = cellfun(@numel, cc_label.PixelIdxList);
        [~, maxIdx] = max(numPix_label);
        % 构造最大连通区域的逻辑掩膜
        maxLabelRegion = false(size(str.label));
        maxLabelRegion(cc_label.PixelIdxList{maxIdx}) = true;
        % 检查与 phi0 是否有重叠
        overlap = maxLabelRegion & str.phi0;
        if any(overlap(:))
            str.prior = maxLabelRegion;
            str.alpha = 5;
        else
            str.prior = false(size(str.label));
            str.alpha = 0;
        end
    else
        % 没有连通区域，输出全假
        str.prior = false(size(str.label));
        str.alpha = 0;
    end

