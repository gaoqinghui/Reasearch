function [m,e]=gmmexm(b,infoz,stat,Y,X,Z)
% GMMEXM  Evaluates gmmexm(b) for use
%         with the GMM package. Power Utility CCAPM example.
%
%   b:    k-vector of model parameters
%   X:    (nobs x k) matrix of exogenous variables
%   Y:    (nobs x neq) matrix of endogenous variables
%   Z:    (nobs x nz) vector of instruments
%
%   e:  (nobs x neq) matrix of conditions of interest
%   m:  north-vector of orthog. cond. from stacking Z'h
%
% For this application:
%   X = [c r], Y = [1 1], Z = [1 lag(c) lag(r)]
%   c:    nobs-vector of consumption growth
%   r:    (neq x 2) matrix of returns, [re rf] (1.1 = 10%)
%   imrs: nobs-vector of IMRSs
%   e:    (nobs x neq) IMRS*r=1
%
%   m_(t) = beta*[c_(t)/c_(t-1)]^-gamma


[T, neq] = size(Y);
k = cols(Z);
north = neq*k;
R = X(:,2:cols(X));
cg = X(:,1);

imrs = b(1)*cg.^(-b(2));
%imrs = b(1) + b(2)*[R(:,2)-1];

%e = (imrs*ones(1,neq)).*R - Y;

e = repmat(imrs,1,neq).*R - Y;
m = reshape(Z'*e/T,north,1);
