function M = logitj(b,infoz,stat,y,x,z)
%function M = logitj(b,infoz,stat,y,x,z)  
%
% Jacobian for Logit Model.  See gmmldv_d for a demo.

[T,k] = size(x);
q = 2*y-1;			% Convert from 0/1 to -1/+1 coding
F = exp(x*b.*q)./(1+exp(x*b.*q));
f = F.*(1-F);
X1 = repmat(F,1,k).*z;
X2 = repmat(1-F,1,k).*z;
M = -X1'*X2;