function g = edge(Img,class)
%计算边缘指示函数，不加输入时认定为测地线活动轮廓
%三种边缘计算方式：  'geodesic' . 'HOS' , 'canny'
if(~exist('class','var'))
    class='geodesic';
end

tem = ones(size(Img(:,:,1)));
switch class
    
    case 'geodesic'
            size3=size(Img,3);
            K=fspecial('gaussian', 3 , 0.8);
            Item = conv2(tem,K,'same');
        for i=1:size3
            I1 = conv2(Img(:,:,i),K,'same');
            I1 = I1./Item;
            %I1 = imfilter(Img,K,'same');
            [IX,IY]=gradient(I1);
            G(:,:,i) = (IX).^2 + (IY).^2;
%             G(:,:,i) = (IX).^2 + (IY).^2 +eps;
        end
        g =  1./( 1 + sum(G,3) );
        
    case 'HOS'
            size3=size(Img,3);
            K=fspecial('average', 3);
            Item = conv2(tem,K,'same');
        for i=1:size3
            I1 = conv2(Img(:,:,i),K,'same');
            I1 = I1./Item;
            HOS(:,:,i) = norm255( (I1 - Img(:,:,i)).^5 );
        end
        g =  mean(1./(1+HOS) ,3);
        
    case 'std'
            size3=size(Img,3);
            K=fspecial('gaussian', 3, 0.8);
            Item = conv2(tem,K,'same');
        for i=1:size3
            I1 = conv2(Img(:,:,i),K,'same');
            I1 = I1./Item;
            gama = sqrt(std2(I1));
            [IX,IY]=gradient(I1);
            G(:,:,i) = ( (IX).^2 + (IY).^2 )./ (gama.^2);
        end
        g =  1./( 1 + sum(G,3) );
        
    case 'Localstd'
            size3=size(Img,3);
            K=fspecial('gaussian', 3);
            Item = conv2(tem,K,'same');
        for i=1:size3
            I1 = conv2(Img(:,:,i),K,'same');
            I1 = I1./Item;
            gama = LocalEntropy(Img,3);
            [IX,IY]=gradient(I1);
            G(:,:,i) = ( (IX).^2 + (IY).^2 )./ (gama.^2);
        end
        g =  1./( 1 + sum(G,3) );
        
    case 'canny'
            size3=size(Img,3);
        for i=1:size3
            BW(:,:,i) = edge3(Img(:,:,i),'approxcanny',0.7);
        end
        g =  mean(1./(2-BW) ,3);
        
end
end

