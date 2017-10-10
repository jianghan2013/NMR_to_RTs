function [R, Ts] = T2T1_conv_RTs(T2, T1)
%Args:
%       T2: scalar / vector/ tensor, must have same dimension as T1
%       T1: scalar / vecotr/ tensor, must have same dimension as T2
%Returns:
%       R: T1 over T2 ratio
%       Ts: T2 secular

        R = T1 ./ T2 ;
        Ts = T2 .* T1 ./ (T1 - T2 );

end