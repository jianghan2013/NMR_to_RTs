function [g_density_grid, G_volume_grid, R_grid, Ts_grid] = Get_g_density( T2_grid, T1_grid, ... 
             f_density_grid, R_domain, Ts_domain)
         
         
        [R_grid, Ts_grid] = meshgrid(R_domain, Ts_domain);
        size_R = size(R_domain);
        size_Ts = size(Ts_domain);
        R_points = size_R(2);
        Ts_points = size_Ts(2);
        n_points = R_points * Ts_points;

        % From R, Ts points to T2, T1 points 
        T2_interp_domain = zeros(1, n_points);
        T1_interp_domain = zeros(1, n_points);
        det_J = zeros(1, n_points);
    
        for Ts_i =1: Ts_points
                for R_i = 1: R_points
                            i = R_points * (Ts_i-1) + R_i;
                            [T2_interp_domain(i), T1_interp_domain(i)] = RTs_conv_T2T1(R_domain(R_i), Ts_domain(Ts_i) );
                            det_J(i) = T2_interp_domain(i) * (R_domain(R_i)-1) / R_domain(R_i);
                end
        end
       
        % interpolation to get f_density_interp, 1D vector 
        f_density_interp = interp2(T2_grid, T1_grid, f_density_grid , T2_interp_domain, T1_interp_domain, 'linear');

        % convert f(T1*(R,Ts) , T2*(R,Ts) ) to g(R,Ts)
        g_density_vec = f_density_interp .* det_J; % vector 

        % from g(R,Ts) get g grid
        [R_domain_vec, Ts_domain_vec] = T2T1_conv_RTs(T2_interp_domain, T1_interp_domain); 
        g_density_grid = griddata(R_domain_vec, Ts_domain_vec, g_density_vec,  R_grid , Ts_grid);% 2D tensor
        g_density_grid(isnan(g_density_grid)) = 0;

        % from g grid get G_volume_grid
        delta_R = abs(GeometricMeanDX(R_domain));
        delta_Ts = abs(GeometricMeanDX(Ts_domain));
        [delta_R_grid, delta_Ts_grid] = meshgrid(delta_R, delta_Ts);
        delta_RTs_grid = delta_R_grid .* delta_Ts_grid; 
        G_volume_grid = g_density_grid .* delta_RTs_grid;



end