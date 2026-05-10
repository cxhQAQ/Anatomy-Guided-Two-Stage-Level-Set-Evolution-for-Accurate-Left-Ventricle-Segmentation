function phi = Numerical(phi, A, L, P, str, param)

switch param.Numerical
    case 'Central'
    timestep = str.timestep;
    phi = phi+timestep*(L+P+A);
    case 'convexity'
    timestep = str.timestep;
    signum = str.signum;
    phi = phi + timestep*( (A + L).*signum + (1-signum).*(str.k).*(str.DrcU).*(str.beta) + P );
end
end


