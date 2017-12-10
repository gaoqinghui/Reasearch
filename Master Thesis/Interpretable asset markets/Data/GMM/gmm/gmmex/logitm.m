function [m,e] = logitm(b,infoz,stat,y,x,z)
%function [m,e] = logitm(b,infoz,stat,y,x,z)
%
% Moments for Logit Model.  See gmmldv_d for a demo.
    
q = 2*y-1;			% Convert from 0/1 to -1/+1 coding
F = exp(x*b.*q)./(1+exp(x*b.*q));
f = F.*(1-F);
F(find(F==0)) = eps;		% Avoids /0 errors when x*b.*q is large neg
e = q.*f./F;
m = z'*e;
