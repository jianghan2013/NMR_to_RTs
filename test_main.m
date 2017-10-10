clear all
close all
addpath('Convert_toolbox\');
%addpath('GIT Matlab Toolbox v 3.0\');
%% Read T1,T2 F_volume from the file.
% T2_domain, T1_domain unit has to be in second 
direct = 'sample_data\';
file_T1T2 = 'Pro_T1T2_2_93_P_20_35_0(a)_05152016.txt';
file_T2_domain = 'T1T2_T2point.txt';
file_T1_domain =  'T1T2_T1point.txt';

%file_T1T2 = strcat(direct,'Pro_T1T2_3_14_H_03062016.txt'); 
file_T1T2 = strcat(direct,file_T1T2); 
file_T2_domain = strcat(direct, file_T2_domain);
file_T1_domain = strcat(direct,file_T1_domain);
T1_domain = importdata(file_T1_domain); % unit of sec
T2_domain = importdata(file_T2_domain); % unit of sec
F_volume_grid = importdata(file_T1T2);

%% Call class 
solution = Class_Conv_RTs();
solution.fit(T2_domain, T1_domain, F_volume_grid); 
solution.check_R_Ts_range()

% Define transformation opts
opts_transform.R_points= 300;
opts_transform.Ts_points = 300;
solution.transform(opts_transform);

% visualization
solution.plot_G(true)
solution.plot_sub_vol()












