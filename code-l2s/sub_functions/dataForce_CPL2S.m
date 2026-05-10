function [dataForce, output2, b] = dataForce_CPL2S(phi, str, param)

output2 = struct();
lambda1 = str.lambda1;
lambda2 = str.lambda2;
epsilon  = str.epsilon ;

lambda_l2 = str.lambda_l2;
A = str.A;
B = str.B;
b = str.b;

for j=1:param.size3
        dataForce1 = 0;
        for i=1:param.Multiscale{3}
            switch param.Filter
                case 'Gauss'
                    Img = str.Img(:,:,j);
                    K = str.Ksigma{i};
                    fk = str.Fiourer.fkg{i};
                    KI = str.KI{i,j};
                    KONE = str.KONE{i};
                case 'mean'
                    Img = str.Img(:,:,j);
                    K = str.Ksigma{i};
                    fk = str.Fiourer.fkm{i};
                    KI = str.KI{i,j};
                    KONE = str.KONE{i};
                case 'doubleFilter'
                    Img = str.Img(:,:,j);
                    K = str.Ksigma.M{i};
                    fk = str.Fiourer.fkm{i};
                    KI = str.KI.M{i,j};
                    KONE = str.KONE.M{i};
            end
            [f1,f2,b] = L2S(Img, phi, A, B, b, lambda_l2);
            s1 = lambda1.*(f1+b).^2-lambda2.*(f2+b).^2;
            s2 = lambda1.*(f1+b)-lambda2.*(f2+b);
            
            dataForce0 = (lambda1-lambda2).*Img.*Img+ s1 -2.*Img.*s2;
            dataForce1 = alg(dataForce1, dataForce0);
        end
        dataForce(:,:,j) = dataForce1;
end
output2.dataForce0 = dataForce0;
output2.f1 = f1;
output2.f2 = f2;

function dataForce1 = alg(dataForce1, dataForce0)
    dataForce1 = dataForce1 + dataForce0;
