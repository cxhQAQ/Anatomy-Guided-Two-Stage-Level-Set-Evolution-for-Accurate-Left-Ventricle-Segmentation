function [phi] = phishow(phi, its, str, param, phi2)
%
    
switch param.Test.phishow{1}
    case 'on'
        if mod(its,param.Test.phishow{2})==0
            figure(str.testName),imagesc(norm255(str.Img));
            colormap(gray),hold on;axis off
            contour(phi,[0 0],'r','LineWidth',1);
            title(its)       
            if nargin == 5
                contour(phi2,[0 0],'b','LineWidth',1);
            end
        end
    case 'off'
        
end

