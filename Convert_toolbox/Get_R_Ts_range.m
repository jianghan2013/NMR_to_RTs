function [result_dict, range_dict, id_T1_GT_T2, id_cutoff] = Get_R_Ts_range1(...
            T2_grid, T1_grid, F_grid, ratio_cutoff, do_plot)
%Args:
%      T2_grid: 2D matrix, shape [n_T1,n_T2], T2 grid points
%      T1_grid: 2D matrix, shape [n_T1, n_T2], T1 grid points
%      F_grid:  2D matrix, shape [n_T1,n_T2],  Volume distribution, F is a function of T2 and T1
%      ratio_cutoff:  float, ratio of  total F retained in the region of T1> T2, convert small value to be 0 
%      do_plot: boolean, if True, then plot the graph
%
%Returns:
%       result_dict: hashmap, 
%               'sum_F': float, the summation of V_grid  
%               'sum_F_T1_GT_T2': float, the summation of V_grid with Y_grid > X_grid
%               'ratio_T1_GT_T2': float,  ratio of sum_v_Y_GT_X over sum_v
%               'sum_F_cutoff': float,  the summation of V_Grid with (Y_grid > X_grid) and V_grid value > cutoff value 
%               'ratio_cutoff_actual': float, ratio of sum_v_cutoff over sum_v
%       range_dict: hashmap,  
%               'R_max', the max value of R 
%               'R_min', 
%               'Ts_max'
%               'Ts_min'
%       
%       

        % determine best cutoff value
        sum_F = sum(sum(F_grid));
        
        % find the coor Y > coor X 
        id_T1_GT_T2 = T1_grid > T2_grid;
        sum_F_T1_GT_T2  = sum(sum(F_grid(id_T1_GT_T2)));
        ratio_T1_GT_T2 = sum_F_T1_GT_T2 / sum_F;
       
        
        % search cut_values so that ratio_cutoff close to ratio_sum_F
        cut_values = logspace(-5,0,100)*sum_F_T1_GT_T2 ;
        delta_min_ = 999;
        F_cutoff_best = 999;
        
        for cut_value = cut_values
                F_grid_cutoff = F_grid;
                id_cutoff = (F_grid >= cut_value)  &  id_T1_GT_T2; % larger than cut_value as well as in the Y>X section
                F_grid_cutoff(~id_cutoff) = 0;
                sum_F_cutoff = sum(sum(F_grid_cutoff));
                ratio_i = sum_F_cutoff / sum_F_T1_GT_T2;
                if abs(ratio_i - ratio_cutoff) < delta_min_
                        delta_min_ = abs(ratio_i - ratio_cutoff);
                        F_cutoff_best = cut_value ;
                end
        end
        
        % use the best cutoff value to get the cutoff
        F_grid_cutoff = F_grid;
        id_cutoff = (F_grid >= F_cutoff_best)  &   id_T1_GT_T2; % id of cutoff 
        F_grid_cutoff(~id_cutoff) = 0;
        sum_F_cutoff = sum(sum(F_grid_cutoff));
        ratio_cutoff_actual= sum_F_cutoff / sum_F_T1_GT_T2;
        
        fprintf('total volume = %f\n', sum_F)
        fprintf('volume (T1> T2) /  total volume = %f \n', ratio_T1_GT_T2)
        fprintf('volume (cutoff) / volume (T1> T2) = %f\n', ratio_cutoff_actual)
        
        keys = {'sum_F', 'sum_F_T1_GT_T2', 'ratio_T1_GT_T2', 'sum_F_cutoff', 'ratio_cutoff_actual'};
        values = [sum_F, sum_F_T1_GT_T2, ratio_T1_GT_T2, sum_F_cutoff, ratio_cutoff_actual];
        result_dict = containers.Map(keys,values); 
        
        % get range  
        [R_grid, Ts_grid] = T2T1_conv_RTs(T2_grid, T1_grid);  %  conver T2, T1 to R and Ts
        R_max = max(max(R_grid(id_cutoff)));
        R_min = min(min(R_grid(id_cutoff)));
        Ts_max = max(max(Ts_grid(id_cutoff)));
        Ts_min =  min(min(Ts_grid(id_cutoff)));
       
        fprintf('R range [%f to %f], Ts range [%f to %f] \n', R_min, R_max, Ts_min, Ts_max)
        fprintf('\n')
        keys ={'R_max', 'R_min', 'Ts_max', 'Ts_min'};
        values = [R_max, R_min, Ts_max, Ts_min];
        range_dict = containers.Map(keys, values);
        
        % plotting 
        if do_plot
                % plot the coor Y > coor X 
                F_grid_plot = F_grid; 
                F_grid_plot(~id_T1_GT_T2) = NaN;
                figure()
                hold on
                pcolor(T2_grid, T1_grid, F_grid_plot)
                plot([1e-5, 1e1],[1e-5, 1e1],'k-','LineWidth',2)
                shading interp 
                xlabel('X-grid')
                ylabel('Y-grid')
                title('Region T1 > T2')
                set(gca,'FontSize',10) %Ticks and legend
                set(gca,'yscale','log')
                set(gca,'xscale','log')
                
                % plot the 
                F_cutoff_plot = F_grid;
                F_cutoff_plot(~id_cutoff) = NaN;
                figure()
                hold on
                pcolor(T2_grid, T1_grid, F_cutoff_plot)
                plot([1e-5, 1e1], [1e-5, 1e1], 'k-', 'LineWidth', 2)
                shading interp 
                xlabel('X-grid')
                ylabel('Y-grid')
                title('after cutoff')
                set(gca,'FontSize',10) %Ticks and legend
                set(gca,'yscale','log')
                set(gca,'xscale','log')
        end

end



