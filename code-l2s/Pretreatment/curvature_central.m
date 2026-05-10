function k = curvature_central(phi)                 

    [ux,uy] = gradient(phi);                                  
    normDu = sqrt(ux.^2+uy.^2+1e-10);	% the norm of the gradient plus a small possitive number 
                                        % to avoid division by zero in the following computation.
    Nx = ux./normDu;                                       
    Ny = uy./normDu;
    nxx = gradient(Nx);                              
    [junk,nyy] = gradient(Ny);                              
    k = nxx+nyy;
end