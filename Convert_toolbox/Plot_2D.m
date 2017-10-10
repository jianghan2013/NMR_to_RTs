function ax = Plot_2D(X_grid, Y_grid, V_grid, opts)
       

        optslist={ 'plot_type',   'pcolor',... % ['plot', 'contour
                    'num_contour', 10, ...
                    'do_xscale_log', true, ...
                    'do_yscale_log', true, ...
                    'do_colorbar',   false,...
                    'title_text', '' ...
                    'Font_size', 10};
        if nargin < 3
                error('not enough input parameter')
        elseif(nargin==3)
                fprintf('Warning: default values for opts are being used.')
                opts=SetOptions(optslist);
        else
                opts=CheckOptions(opts,optslist);   
        end
        
        figure()
        
        hold on
        
        if strcmp(opts.plot_type, 'contour')
                [C H] = contour(X_grid, Y_grid, V_grid, opts.num_contour);  
        else
             
                pcolor(X_grid, Y_grid, V_grid);
        end
                x_min = min(min(X_grid));
                x_max = max(max(X_grid));
                y_min = min(min(Y_grid));
                y_max = max(max(Y_grid));
                
                shading interp 
                title(opts.title_text)
                axis([x_min x_max y_min y_max])
                xlabel('X-grid')
                ylabel('Y-grid')
            
                set(gca,'FontSize',opts.Font_size) %Ticks and legend
            
        if opts.do_xscale_log
                set(gca,'xscale','log')
        end
        
        if opts.do_yscale_log
                set(gca,'yscale','log')
        end
        
        if opts.do_colorbar
                colorbar
        end
        
        ax = gca;
        
end




