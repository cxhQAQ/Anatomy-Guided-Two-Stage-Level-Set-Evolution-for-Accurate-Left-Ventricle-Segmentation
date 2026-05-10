function I = norm255(input);
I1 = max(input ,[],'all');
I2 = min(input ,[],'all');
I  = (input - I2)./(I1 - I2 + eps);
I = I*255;