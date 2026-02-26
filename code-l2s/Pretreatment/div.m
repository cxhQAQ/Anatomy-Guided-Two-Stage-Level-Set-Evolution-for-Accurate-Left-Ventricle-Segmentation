function f = div(nx,ny)
% 梯度计算曲率
[nxx,junk]=gradient(nx);  
[junk,nyy]=gradient(ny);
f=nxx+nyy;
