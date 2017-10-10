function vol_sub = Get_vol_7zones(X_grid, Y_grid, V_grid)
        
        
        vol_sub = zeros(7,1);
        
        % v1
        id_x1 = X_grid < 10^1;
        id_y1 = Y_grid >= 10^(-2);
        id_xy1 = id_x1 & id_y1;
        vol_sub(1) = sum(sum(V_grid(id_xy1)));      
        
        % v2
        id_x2= X_grid >= 10^1 & X_grid <10^2  ;
        id_y2 = id_y1 ;
        id_xy2 = id_x2 & id_y2;
        vol_sub(2) = sum(sum(V_grid(id_xy2)));
        
        % v3
        id_x3= X_grid >= 10^2 ;
        id_y3 = Y_grid >= 10^(-4);
        id_xy3 = id_x3 & id_y3;
        vol_sub(3) = sum(sum(V_grid(id_xy3)));   
        
        % v4
        id_x4 = id_x1;
        id_y4 = ~id_y1;
        id_xy4 = id_x4 & id_y4;
        vol_sub(4) = sum(sum(V_grid(id_xy4)));       
        
        %v5
        id_x5 =  id_x2  ;
        id_y5 = Y_grid < 10^(-2) & Y_grid >= 10^-4 ;
        id_xy5 = id_x5 & id_y5;
        vol_sub(5) = sum(sum(V_grid(id_xy5)));
        % v6 
        id_x6 = id_x2  ;
        id_y6 = Y_grid < 10^(-4);
        id_xy6 = id_x6 & id_y6;
        vol_sub(6) = sum(sum(V_grid(id_xy6)));
        
        % v7    
        id_x7 = id_x3  ;
        id_y7 = id_y6 ;
        id_xy7 = id_x7 & id_y7;
        vol_sub(7) = sum(sum(V_grid(id_xy7)));
        
        % checking
        vol_total = sum(sum(V_grid));
        ratio = sum(vol_sub)/vol_total;
        fprintf('   sum(vol_sub) / vol_total = %4.2f \n', ratio)
        
       
        
        
end