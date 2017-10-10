clear all
close all
addpath('Convert_toolbox\');
%addpath('GIT Matlab Toolbox v 3.0\');
%% Read T1,T2 F_volume from the file.
%filename = '1'

% save(file_T1T2,'sample_vol','-ascii');
% save(file_T2point,'sample_T2','-ascii');
% save(file_T1point,'sample_T1','-ascii');
direct = 'sample_data\';
file_T1T2 = strcat(direct,'Pro_T1T2_3_14_H_03062016.txt');
file_T1_domain = strcat(direct, 'T1T2_T1point.txt');
file_T2_domain = strcat(direct, 'T1T2_T2point.txt');

T1_domain = importdata(file_T1_domain)/10^6; % convert to unit of sec
T2_domain = importdata(file_T2_domain)/10^6; % convert to unit of sec
F_volume_grid = importdata(file_T1T2);


%% Get 
R_points = 300;
Ts_points = 300;
R_max =2000;
R_min =1.001;
Ts_min = 10^(-5);
Ts_max = 30;
% Define R and Ts domain
R_domain = logspace(log10(R_min), log10(R_max), R_points); % define R point x,
Ts_domain = logspace(log10(Ts_min), log10(Ts_max), Ts_points); % define Ts point y,


solution = Class_Conv_RTs();
solution.fit(T2_domain, T1_domain, F_volume_grid);
solution.check_R_Ts_range()

opts_transform.R_points= 300;
opts_transform.Ts_points = 300;
%opts_transofrm.R_max  =   100;
solution.transform(opts_transform);
%%
solution.plot_G(true)

% [g_density_grid, G_volume_grid, R_grid, Ts_grid] = get_g_density( T2_grid, T1_grid, ... 
%              f_density_grid, R_domain, Ts_domain);
% figure()
% pcolor(T2_domain, T1_domain, f_density_T1T2)
% shading interp 
% set(gca,'FontSize',10) %Ticks and legend
% set(gca,'yscale','log')
% set(gca,'xscale','log')

%% Find the range of R and Ts.




% get g_density, G_volume 

         
% sum_G =  sum(sum(solution.G_vol_grid));
% sum_F_Y_GT_X =  sum(sum(solution.F_vol_grid(solution.id_Y_GT_X)));
% ratio_recover  =  sum_G/ sum_F_Y_GT_X;
% fprintf( 'volume of G %4.3f,  volume F ( Y>X) %4.3f, ratio %4.3f \n', sum_G, sum_F_Y_GT_X, ratio_recover)
% %pcolor(R_grid, Ts_grid, G_volume_grid)
% close all
% opts_plot.plot_type = 'contour';
% ax = Plot_2D(solution.R_grid, solution.Ts_grid, solution.G_vol_grid, opts_plot);
% plot(ax, [10 10],[10^-5 10^0],'k--','LineWidth',2)
% plot(ax, [100 100],[10^-5 10^0],'k--','LineWidth',2)
% plot(ax, [1 100],[10^-2 10^-2],'k--','LineWidth',2)
% plot(ax, [10 1000],[10^-4 10^-4],'k--','LineWidth',2)










