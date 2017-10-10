function [result_dict, range_dict, id_Y_GT_X, id_cutoff] = Get_R_Ts_range(X_grid, Y_grid, V_grid, ratio_cutoff, do_plot)
%Args:
%      X_grid: 2D matrix, shape [ny,nx]
%      Y_grid: 2D matrix, shape [ny, nx] 
%      V_grid:  2D matrix, shape [ny,nx],  V(i,j) = f(X_grid(i,j),Y_grid(i,j))
%      ratio_cutoff:  float, ratio of the value V retained, make small value = 0
%      do_plot: boolean, if True, then plot the graph

%Returns:
%       result_dict: hashmap, 
%               'sum_v': float, the summation of V_grid  
%               'sum_v_Y_GT_X': float, the summation of V_grid with Y_grid > X_grid
%               'ratio_Y_GT_X': float,  ratio of sum_v_Y_GT_X over sum_v
%               'sum_v_cutoff': float,  the summation of V_Grid with (Y_grid > X_grid) and V_grid value > cutoff value 
%               'ratio_cutoff_actual': float, ratio of sum_v_cutoff over sum_v
%       range_dict: hashmap,  
%               'R_max', the max value of R 
%               'R_min', 
%               'Ts_max', 
%               'Ts_min'
%       
%       
        
        % determine best cutoff value
        sum_v = sum(sum(V_grid));
        
        % find the coor Y > coor X 
        id_Y_GT_X = Y_grid > X_grid;
        sum_v_Y_GT_X  = sum(sum(V_grid(id_Y_GT_X)));
        ratio_Y_GT_X = sum_v_Y_GT_X / sum_v;
       
        
        % search cut_values so that ratio_cutoff close to ratio_sum_v
        cut_values = logspace(-5,0,100)*sum_v_Y_GT_X ;
        delta_min = 999;
        v_cutoff_best = 999;
        
        for cut_value = cut_values
                V_grid_cutoff = V_grid;
                id_cutoff = (V_grid >= cut_value)  &  id_Y_GT_X; % larger than cut_value as well as in the Y>X section
                V_grid_cutoff(~id_cutoff) = 0;
                sum_v_cutoff = sum(sum(V_grid_cutoff));
                ratio_i = sum_v_cutoff / sum_v_Y_GT_X;
                if abs(ratio_i - ratio_cutoff) < delta_min
                        delta_min = abs(ratio_i - ratio_cutoff);
                        v_cutoff_best = cut_value ;
                end
        end
        
        % use the best cutoff value to get the cutoff
        V_grid_cutoff = V_grid;
        id_cutoff = (V_grid >= v_cutoff_best)  &  id_Y_GT_X;
        V_grid_cutoff(~id_cutoff) = 0;
        sum_v_cutoff = sum(sum(V_grid_cutoff));
        ratio_cutoff_actual= sum_v_cutoff / sum_v_Y_GT_X;
        
        % get range 
        T2_grid = X_grid; 
        T1_grid = Y_grid; 
        [R_grid, Ts_grid] = T2T1_conv_RTs(T2_grid, T1_grid); 
        R_max = max(max(R_grid(id_cutoff)));
        R_min = min(min(R_grid(id_cutoff)));
        Ts_max = max(max(Ts_grid(id_cutoff)));
        Ts_min =  min(min(Ts_grid(id_cutoff)));
        
        % results
        fprintf('total volume = %f\n', sum_v)
        fprintf('volume (Y> X) /  total volume = %f \n', ratio_Y_GT_X)
        fprintf('volume (cutoff) / volume (Y> X) = %f\n', ratio_cutoff_actual)
        fprintf('R range [%f to %f], Ts range [%f to %f] \n', R_min, R_max, Ts_min, Ts_max)
        fprintf('\n')
        keys = {'sum_v', 'sum_v_Y_GT_X', 'ratio_Y_GT_X', 'sum_v_cutoff', 'ratio_cutoff_actual'};
        values = [sum_v, sum_v_Y_GT_X, ratio_Y_GT_X, sum_v_cutoff, ratio_cutoff_actual];
        result_dict = containers.Map(keys,values); 
        
        keys ={'R_max', 'R_min', 'Ts_max', 'Ts_min'};
        values = [R_max, R_min, Ts_max, Ts_min];
        range_dict = containers.Map(keys, values);
        
        % plotting 
        if do_plot
                % plot the coor Y > coor X 
                V_grid_plot = V_grid; 
                V_grid_plot(~id_Y_GT_X) = NaN;
                figure()
                hold on
                pcolor(X_grid, Y_grid, V_grid_plot)
                plot([1e-5, 1e1],[1e-5, 1e1],'k-','LineWidth',2)
                shading interp 
                xlabel('X-grid')
                ylabel('Y-grid')
                title('coor Y > coor X')
                set(gca,'FontSize',10) %Ticks and legend
                set(gca,'yscale','log')
                set(gca,'xscale','log')
                
                % plot the 
                V_cutoff_plot = V_grid;
                V_cutoff_plot(~id_cutoff) = NaN;
                figure()
                hold on
                pcolor(X_grid, Y_grid, V_cutoff_plot)
                plot([1e-5, 1e1],[1e-5, 1e1],'k-','LineWidth',2)
                shading interp 
                xlabel('X-grid')
                ylabel('Y-grid')
                title('after cutoff')
                set(gca,'FontSize',10) %Ticks and legend
                set(gca,'yscale','log')
                set(gca,'xscale','log')
        end

end



