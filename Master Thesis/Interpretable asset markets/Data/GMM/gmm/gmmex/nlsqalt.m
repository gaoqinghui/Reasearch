function f=nlsqalt(b)
%function f=nlsqalt(b)
%
% Used in demo nlsq_d to compare with nonlinear least squares from minz.
% nlsqalt is the function used by the lsqnonlin, part of Matlab's 
% Optimization Toolbox.
 
nlsqdat
yhat =  b(1)*x + b(2)*x.^2 + b(3)*x.^3 + b(4)*cos(b(5)*x);
f = y - yhat;
