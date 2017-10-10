function [T2, T1] = RTs_conv_T2T1(R, Ts)
%Args:
%       R: scalar / vector/ tensor, T1 over T2 ratio, must have same dimension as T1
%       Ts: scalar / vecotr/ tensor,  T2 secular, must have same dimension as T2

%Returns:
%       T2: same dimension as R
%       T1: same dimension as R

            T1 = Ts .* (R - 1);
            T2 = T1 ./ R;
            
end