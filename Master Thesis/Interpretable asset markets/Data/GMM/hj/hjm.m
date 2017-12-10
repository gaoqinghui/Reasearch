function [m,e] = hjm(b,infoz,stat,y,x,z,w)

% y is price vector
% x is [d R]  d is target (model) sdf, R is basis assets
% z is vector of ones
% SDF is d - R*b.  For NA, infoz.nadum = 1 and SDF is max(d - R*b,0)
%
% See HJ.M for more information.
%  
%  VERSION 1.0 (10/4/00)

%  PROGRAMMER:   Mike Cliff,  Purdue Finance,  mcliff@mgmt.purdue.edu
%  WRITTEN:      10/4/00

  
  
[T,k] = size(y);
if cols(x) == k
  d = 0;
elseif cols(x) == k+1
  d = x(:,1);
  x = x(:,2:end);
else
  error('Mismatch on dimensions of x and b')
end

sdf = d - x*b;
if isfield(infoz,'nadum')
  if infoz.nadum == 1
    sdf = max(sdf,0);
  end
end

e = [x.*repmat(sdf,1,k) - y];
m = mean(e)';


