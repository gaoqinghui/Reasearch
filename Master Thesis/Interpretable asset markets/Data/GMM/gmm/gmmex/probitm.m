function [m,e] = probitm(b,infoz,stat,y,x,z)
%function [m,e] = probitm(b,infoz,stat,y,x,z)
%
% Moments forProbit Model.  See gmmldv_d for a demo.
  
q = 2*y-1;			% Convert from 0/1 to -1/+1 coding
F = normcdf(x*b.*q);
f = normpdf(x*b.*q);
e = q.*f./F;
m = z'*e;
