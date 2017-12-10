function M = probitj(b,infoz,stat,y,x,z)%
%function M = probitj(b,infoz,stat,y,x,z)
%
% Jacobian for Probit Model.  See gmmldv_d for a demo.
  
[T,k] = size(x);
q = 2*y-1;			% Convert from 0/1 to -1/+1 coding
F = normcdf(x*b.*q);
f = normpdf(x*b.*q);
lambda = q.*f./F;
X1 = repmat(lambda,1,k).*z;
X2 = repmat(lambda+x*b,1,k).*z;
M = -X1'*X2;