% Some predefine parameters
clear all
R_points = 3;
Ts_points = 2;
R_domain = [2,4,6]; % define R point x,
Ts_domain = [3,5]; % define Ts point y,
T2_domain = [1:0.5:10]; % input T2_domain
T1_domain = [2:5:30]; % input T1_domain
shape_T2 = size(T2_domain)
shape_T1 = size(T2_domain)
T2_points = shape_T2(2);
T1_points = shape_T1(2);


%% testing f_density 
% Args:
%           , 
%   
T2 = R_domain;
T1 = Ts_domain;
delta_T2 = T2;% should be T2_point
delta_T1 = T1;% should be T1_point
F_volume = [1,2,3;
                    2,3,4]; % input F_density 
[delta_T2_grid, delta_T1_grid] = meshgrid(delta_T2, delta_T1);
% main 
delta_T2T1_grid = delta_T2_grid .* delta_T1_grid;
f_density = F_volume ./ delta_T2T1_grid;
% Return f_density 

%testing start
delta_T2T1_grid_test = zeros(Ts_points,R_points);
f_density_test = zeros(Ts_points,R_points);
for i =1: Ts_points
    for j = 1:R_points   
        delta_T2T1_grid_test(i,j) = delta_T1(i)* delta_T2(j);
        f_density_test(i,j) = F_volume(i,j) / delta_T2T1_grid_test(i,j);
    end
end
test_eq_5 = sum(sum(abs(delta_T2T1_grid  - delta_T2T1_grid_test)))
test_eq_6 = sum(sum(abs(f_density_test  - f_density)))
%testing end 

%% Test T2*,T1*, det_Jocabi, 
[R_grid, Ts_grid] = meshgrid(R_domain, Ts_domain); %create 2d matrix, shape(n_y, n_x)

% Calculate T2* , T1*
T1_grid_star = (Ts_grid .*(R_grid-1));
T2_grid_star = (Ts_grid .*(R_grid-1)) ./ R_grid;
det_Jocabi_grid =  Ts_grid .* (R_grid - 1).^2 ./ (R_grid.^2)

% testing start
T1_grid_star_test  = zeros(Ts_points,R_points);
T2_grid_star_test  = zeros(Ts_points,R_points);
det_Jocabi_grid_test =  zeros(Ts_points,R_points);
f_density_interp_test =  zeros(Ts_points, R_points); 
for i = 1: Ts_points
    for j = 1:R_points 
        T1_grid_star_test(i,j) = Ts_domain(i)*(R_domain(j)-1);
        T2_grid_star_test(i,j) = Ts_domain(i)*(R_domain(j)-1)/R_domain(j);
        det_Jocabi_grid_test(i,j) = Ts_domain(i) * (R_domain(j)-1)^2 / R_domain(j)^2;
    end
end
test_eq_1 = sum(sum(abs(T1_grid_star_test - T1_grid_star)))
test_eq_2 = sum(sum(abs(T2_grid_star_test - T2_grid_star)))
test_eq_3 = sum(sum(abs(det_Jocabi_grid_test -det_Jocabi_grid )))
% testing end

%% Test f_density_interp 

[T2_grid, T1_grid] = meshgrid( T2_domain, T1_domain);
f_density_grid = T2_grid + T1_grid;
f_density_interp = interp2(T2_grid, T1_grid, f_density_grid, T2_grid_star, T1_grid_star);
f_density_interp_test = zeros(Ts_points,R_points);
% testing
for i = 1:Ts_points
    for j = 1:R_points
        f_density_interp_test(i,j) = interp2(T2_grid, T1_grid, f_density_grid, T2_grid_star(i,j), T1_grid_star(i,j));
    end
end
test_eq_4 = sum(sum(abs(f_density_interp_test - f_density_interp)))

close all
figure()
surf(T2_grid, T1_grid, f_density_grid )
hold on
plot3(T2_grid,T1_grid,f_density_grid ,'ko')
plot3(T2_grid_star, T1_grid_star, f_density_interp_test,'ro')
plot3(T2_grid_star, T1_grid_star, f_density_interp,'g*')
xlabel('T2')
ylabel('T1')
grid on
% testing end 





