classdef Class_Conv_RTs < handle
% The class take T2, T1 and their volume distribution F_volume_grid,
%       convert into R and Ts and g_den_grid 
%
% Returns(selected):
%       obj.f_den_grid; obj.G_vol_grid; obj.g_den_grid; obj.G_vol_grid; obj. g_den_grid;   
%       obj.result_dic; obj.range_dict; 
%
% To call this class
%       define 1D vector T2_domain, 1D vector T1_domain, 2D grid F_volume_grid 
%       define 1D vector R_domain, Ts_domain. 
%       solution = Class_Conv_RTs();
%       solution.fit(T2_domain, T1_domain, F_volume_grid);
%       solution.transform(R_domain, Ts_domain);

        properties
                T1_domain = 'undefined'; % 1D vector, shape(n_T1), T1 relaxation points,  user defined 
                T2_domain = 'undefined';  % 1D vector, shape(n_T2), T2 relaxation points, user defined
                T1_grid = 'undefined'; % 2D vector, shape(n_T1, n_T2), the grid point of T1_domain
                T2_grid = 'undefined'; % 2D vector, shape(n_T1, n_T2), the grid point of T2_domain
                
                R_domain = 'undefined'; % 1D vector, shape(n_R),   T1 / T2 ratio, user defined  
                Ts_domain = 'undefined'; % 1D vector, shape(n_Ts). T2 secular.  user defined 
                R_grid =  'undefined';  % 2D vector, shape(n_Ts, n_R), the grid point of R_domain
                Ts_grid =  'undefined'; % 2D vector, shape(n_Ts, n_R), the grid point of Ts_domain
                
                
                F_vol_grid = 'undefined'; % 2D vector, shape(n_T1, n_T2), the volume distribution F(T2,T1), sum(F) = pore volume 
                f_den_grid = 'undefined'; % 2D vector, shape(n_T1, n_T2), the density distribution f(T2,T1), sum(f* delta_dT2T1) = pore volume
                G_vol_grid =  'undefined';  % 2D vector, shape(n_Ts, n_R), the volume distribution G(R,Ts), sum(G) = pore volume 
                g_den_grid =  'undefined';  % 2D vector, shape(n_Ts, n_R), the density distribution g(R,Ts), sum(g* delta_dRTs) = pore volume 
                
                
                % haspmap, keys = {'sum_F', 'sum_F_T1_GT_T2', 'ratio_T1_GT_T2', 'sum_F_cutoff', 'ratio_cutoff_actual'}; 
                result_dic ='undefined'; 
                % 
                range_dict = 'undefined';
                id_Y_GT_X = 'undefined';
                id_cutoff = 'undefined';
                
                
        end
         
         methods
             
                function obj = fit(obj, T2_domain, T1_domain, F_vol_grid)
                % Take T2, T1 and F_vol_grid, meshgrid to get T2_grid, T1_grid, 
                % calculate density distribution f_den_grid
                        size_T2 = size(T2_domain)
                        size_T1 = size(T1_domain)
                        size_F   =  size(F_vol_grid)
                        if size_T2(1) ~= size_F(2) || size_T1(1) ~= size_F(1) || size_T2(2) ~= 1 || size_T1(2) ~= 1
                                error('size error, T2 size (%d,%d); T1 size (%d, %d); F size (%d,%d) \n',...
                                        size_T2(1), size_T2(2), size_T1(1), size_T1(2), size_F(1), size_F(2))
                        end
                
                        obj.T2_domain = T2_domain;
                        obj.T1_domain = T1_domain;
                        obj.F_vol_grid = F_vol_grid;
                        [obj.T2_grid, obj.T1_grid] = meshgrid(obj.T2_domain, obj.T1_domain); 
                        obj.f_den_grid = obj.get_f_density_();
                        
                end
                
                function obj = transform(obj, opts)
                        %Take predefined R_domain, Ts_domain, 
                        % transform from density distribution f(T2,T1) f_density to
                        % density distribution g(R, Ts) g_den_grid, and volume distribution G(R, Ts) G_vol_grid
                        %
                        %Opts:
                        %       R_points: int, number of points of R
                        %       Ts_points: 
                        %Returns:
                        %       obj
                        
                         optslist={'R_points',  300,...
                                        'Ts_points',    300,...
                                        'R_min',    1.0001,...   
                                        'R_max',    2000,...
                                        'Ts_min', 10^(-5),...
                                        'Ts_max', 30};
                        if(nargin==1)
                                fprintf('Warning: default values for opts are being used.')
                                opts=SetOptions(optslist);
                        else
                                opts=CheckOptions(opts,optslist);   
                        end
                      
                        % Provided by user
                        R_points = opts.R_points
                        Ts_points = opts.Ts_points
                        R_min =opts.R_min
                        R_max =opts.R_max
                        Ts_min = opts.Ts_min
                        Ts_max = opts.Ts_max
                        
                        % Define R and Ts domain in log space 
                        obj.R_domain = logspace(log10(R_min), log10(R_max), R_points); % define R point x,
                        obj.Ts_domain = logspace(log10(Ts_min), log10(Ts_max), Ts_points); % define Ts point y,  
                        [obj.g_den_grid, obj.G_vol_grid, obj.R_grid, obj.Ts_grid] = Get_g_density(...
                                obj.T2_grid, obj.T1_grid, obj.f_den_grid, obj.R_domain, obj.Ts_domain);
           
                end
                
                function check_R_Ts_range(obj, opts) 
                        % Provide guidance for the R and Ts range from given T2,T2 and F    
                        optslist={'ratio',   0.99,...
                                    'do_plot', true}
                        if(nargin==1)
                                fprintf('Warning: default values for opts are being used.')
                                opts=SetOptions(optslist);
                        else
                                opts=CheckOptions(opts,optslist);   
                        end
                      
                        ratio = opts.ratio;
                        do_plot = opts.do_plot;
                        [obj.result_dic, obj.range_dict, obj.id_Y_GT_X,obj.id_cutoff] = Get_R_Ts_range1(...
                        obj.T2_grid, obj.T1_grid, obj.F_vol_grid, ratio, do_plot);
                    
                end
               
                function ax = plot_G(obj, do_coutour)
                        if nargin==1
                                ax = Plot_2D(obj.R_grid, obj.Ts_grid, obj.G_vol_grid);
                        else
                                if do_coutour
                                        opts.plot_type = 'contour';
                                else
                                        opts.plot_type ='pcolor'; 
                                end
                                ax = Plot_2D(obj.R_grid, obj.Ts_grid, obj.G_vol_grid,opts);
                        end
                       
                        plot(ax, [10 10],[10^-5 10^0],'k--','LineWidth',2)
                        plot(ax, [100 100],[10^-5 10^0],'k--','LineWidth',2)
                        plot(ax, [1 100],[10^-2 10^-2],'k--','LineWidth',2)
                        plot(ax, [10 1000],[10^-4 10^-4],'k--','LineWidth',2)
                  
                end
                    
                    
                % internal function, need not be called by instance
                function f_density_grid = get_f_density_(obj)
                    
                        delta_T2 = GeometricMeanDX( obj.T2_domain);
                        delta_T1 = GeometricMeanDX( obj.T1_domain);
                        [delta_T2_grid, delta_T1_grid] = meshgrid(delta_T2, delta_T1);
                        delta_T1T2_grid = delta_T2_grid .* delta_T1_grid; 
                        f_density_grid = obj.F_vol_grid ./ delta_T1T2_grid; 
                        
                end
                  
              
          end
          
end