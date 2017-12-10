function [m,e]=ckls_dm(b,infoz,stat,y,X,Z)

% X is r(t-1), y is r(t)-r(t-1) Z is [1 r(t-1)]
% See ckls_d for a more complete specification of the model
%
% infoz.parms is a 4-vector indicating if the pararmeter is restricted
%   To impose a restriction, pass the value in the desired element, else
%   pass a NaN.
%   The parameter vector is arranged as [alpha beta sigmasq gamma]

% --- Grab parameters out of b, Find parameters that are fixed -------
parms = repmat(NaN,4,1);
parms(isnan(infoz.parms)) = b;
parms(~isnan(infoz.parms)) = infoz.parms(~isnan(infoz.parms));
alpha = parms(1);
beta = parms(2);
sigsq = parms(3);
gamma = parms(4);
  

% --- Form model residuals -------------------------------------------  
T = rows(X);
e1 = y - (alpha + beta*X)/12;
e2 = e1.^2 - (sigsq*X.^(2*gamma))/12;
e = [e1 e2];

% --- Moments are inner product with instruments ---------------------
m = reshape(Z'*e/T,4,1);


