% param.Filter        = 'doubleFilter';
% param.Multiscale    = {'single',4,1};
% param.Pretreatment  = {'log'};

%param.Multiscale    = {'Multi',5,4};
%param.Filter        = 'doubleFilter';
% %% 快速卷积
str.Fiourer.methon = '4n';
str.Fiourer.Length = fftw2n(str.Img, str.sigma, param.Multiscale, str.Fiourer.methon);

%多尺度
    IONE=ones(size(str.Img(:,:,1)));    
for j=1:param.size3
switch param.Multiscale{1}
    case 'single'
        switch param.Filter
            case 'Gauss'
                Ksigma{1} = fspecial('gaussian', 4.*str.sigma+1, str.sigma);
                str.Fiourer.fkg{1} = fft2(Ksigma{1}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                [KI{1,j}, KONE{1}] = fconv2(str.Img(:,:,j), IONE, Ksigma{1}, str.Fiourer.fkg{1}, str.Fiourer.Length);

            case 'mean'
                Ksigma{1} = fspecial('average', 2*str.sigma+1);
                str.Fiourer.fkm{1} = fft2(Ksigma{1}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                [KI{1,j}, KONE{1}] = fconv2(str.Img(:,:,j), IONE, Ksigma{1}, str.Fiourer.fkm{1}, str.Fiourer.Length);

            case 'doubleFilter'
                Ksigma.G{1} = fspecial('gaussian', 4.*str.sigma+1, str.sigma);
                str.Fiourer.fkg{1} = fft2(Ksigma.G{1}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                
                Ksigma.M{1} = fspecial('average', 2*str.sigma+1);
                str.Fiourer.fkm{1} = fft2(Ksigma.M{1}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                
                [KI.G{1,j}, KONE.G{1}] = fconv2(str.Img(:,:,j), IONE, Ksigma.G{1}, str.Fiourer.fkg{1}, str.Fiourer.Length);
                [KI.M{1,j}, KONE.M{1}] = fconv2(str.Img(:,:,j), IONE, Ksigma.M{1}, str.Fiourer.fkm{1}, str.Fiourer.Length);
                
            case 'Bilateral'
                error('双边滤波器未定义')
        end
    case 'Multi'
        for i=1:param.Multiscale{3}
                switch param.Filter
                    case 'Gauss'
                        Ksigma{i}=fspecial('gaussian',4.*( str.sigma + (i-1).*param.Multiscale{2})...
                            +1, str.sigma + (i-1).*param.Multiscale{2} );
                        str.Fiourer.fkg{i} = fft2(Ksigma{i}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                        [KI{i,j}, KONE{i}] = fconv2(str.Img(:,:,j), IONE, Ksigma{i}, str.Fiourer.fkg{i}, str.Fiourer.Length);
                        
                    case 'mean'
                        Ksigma{i}=fspecial('average',2.*( str.sigma + (i-1).*param.Multiscale{2})+1);
                        str.Fiourer.fkm{i} = fft2(Ksigma{i}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                        [KI{i,j}, KONE{i}] = fconv2(str.Img(:,:,j), IONE, Ksigma{i}, str.Fiourer.fkm{i}, str.Fiourer.Length);
                        
                    case 'doubleFilter'
                        Ksigma.G{i}=fspecial('gaussian',4.*( str.sigma + (i-1).*param.Multiscale{2})...
                            +1, str.sigma + (i-1).*param.Multiscale{2} );
                        Ksigma.M{i}=fspecial('average',2.*( str.sigma + (i-1).*param.Multiscale{2})+1);
                        
                        KONE.G{i}={conv2(IONE,Ksigma.G{i},'same')};
                        KONE.M{i}={conv2(IONE,Ksigma.M{i},'same')};
                        
                        KI.G{i,j}={conv2(str.Img(:,:,j),Ksigma.G{i},'same')};
                        KI.M{i,j}={conv2(str.Img(:,:,j),Ksigma.M{i},'same')};
                        
                        
                        str.Fiourer.fkg{i} = fft2(Ksigma.G{i}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                        str.Fiourer.fkm{i} = fft2(Ksigma.M{i}, str.Fiourer.Length(1), str.Fiourer.Length(2));
                        [KI.G{i,j}, KONE.G{i}] = fconv2(str.Img(:,:,j), IONE, Ksigma.G{i}, str.Fiourer.fkg{i}, str.Fiourer.Length);
                        [KI.M{i,j}, KONE.M{i}] = fconv2(str.Img(:,:,j), IONE, Ksigma.M{i}, str.Fiourer.fkm{i}, str.Fiourer.Length);
                    case 'Bilateral'
                        error('双边滤波器未定义')
                end
        end
end
end
        str.Ksigma = Ksigma;
        str.KONE   = KONE;
        str.KI     = KI;

