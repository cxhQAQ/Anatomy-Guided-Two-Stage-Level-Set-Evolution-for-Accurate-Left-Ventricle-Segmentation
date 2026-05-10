function hd = hausdorff_distance(seg, gt)
% HAUSDORFF_DISTANCE 计算两个二值图像之间的双向 Hausdorff 距离
%   seg : 分割结果（逻辑或数值矩阵，非零为前景）
%   gt  : 真实标注（与 seg 同尺寸，非零为前景）
%   返回 hd : 双向 Hausdorff 距离（欧氏距离单位，与图像像素尺寸一致）

    % 提取前景点的坐标 (x, y) 即 (列, 行)
    [row_seg, col_seg] = find(seg);
    A = [col_seg, row_seg];          % 分割结果前景点集

    [row_gt, col_gt] = find(gt);
    B = [col_gt, row_gt];            % 真实标注前景点集

    % 检查点集是否为空
    if isempty(A) || isempty(B)
        hd = NaN;          % 按需求设置为 NaN
        return;
    end

    % 计算 A 到 B 的单向 Hausdorff 距离
    D_AB = pdist2(A, B);             % 所有点的距离矩阵 (|A| x |B|)
    min_AB = min(D_AB, [], 2);       % 每个 A 中点到 B 的最近距离
    h_AB = max(min_AB);              % A→B 的最大最小距离

    % 计算 B 到 A 的单向 Hausdorff 距离
    D_BA = pdist2(B, A);             % 距离矩阵 (|B| x |A|)
    min_BA = min(D_BA, [], 2);
    h_BA = max(min_BA);

    % 双向 Hausdorff 距离
    hd = max(h_AB, h_BA);
end