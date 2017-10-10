function dx = GeometricMeanDX( x )
%   Given the x vector:
% x1 x2 x3 x4 ... xN
% it returns the column vector dx = x_(i+1/2)-x_(i-1/2)
% where x_(i+1/2) = sqrt(x_(i+1)*x_(i))

sx=size(x);
if(sx(1)==1)
    x=x';
end

dx=diff([sqrt(x(1)^3/x(2)); sqrt(x(2:end).*x(1:end-1)); sqrt(x(end)^2*x(2)/x(1))]);
end

