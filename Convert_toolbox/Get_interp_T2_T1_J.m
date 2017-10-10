function [T2_interp_domain, T1_interp_domain, det_J] = Get_interp_T2_T1_J(R_domain, Ts_domain) 
%Input predefined R and Ts points, to calculate corresponding T2,T1 points and
%      determinate of Jocabi matrix

%Args:
%      R_domain: size(1,n_R), vector, R (T1/T2 ratio) points 
%      Ts_domain: size(1,n_Ts), vector, Ts(T2 secular) points

%Returns:
%      T2_interp_domain: size(1,n_R*n_Ts), vector, T2 = Ts(R-1)/R
%      T1_interp_domain: size(1,n_R*n_Ts), vector, T1 = Ts(R-1)
%      det_J: size(1,n_R*n_Ts), vector, det_J = Ts(R-1)^2/R^2, Jacobi
%               matrix |d(T2,T1)/d(R,Ts)|, expressed in (R,Ts)

    size_R = size(R_domain);
    size_Ts = size(Ts_domain);
    R_points = size_R(2);
    Ts_points = size_Ts(2);
    n_points = R_points * Ts_points;

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
end
