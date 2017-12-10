function G=ckls_dj(b,infoz,stat,y,X,Z)

% X is r(t-1), y is r(t)-r(t-1) Z is [1 r(t-1)]
% See ckls_d for a more complete specification of the model
%
% infoz.parms is a 4-vector indicating if the pararmeter is restricted
%   To impose a restriction, pass the value in the desired element, else
%   pass a NaN.
%   The parameter vector is arranged as [alpha beta sigmasq gamma]
  
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

% --- Take partials of residuals wrt parameters ----------------------
de1db1 = -ones(T,1)/12;
de1db2 = -X/12;
de1db3 = zeros(T,1);
de1db4 = zeros(T,1);
de2db1 = 2*e1.*de1db1;
de2db2 = 2*e1.*de1db2;
de2db3 = -X.^(2*gamma)/12;
de2db4 = -2*sigsq*X.^(2*gamma).*log(X)/12;

% --- Form Jacobian by inner product with instruments ----------------
G = [Z'*[de1db1 de1db2 de1db3 de1db4]; ...
     Z'*[de2db1 de2db2 de2db3 de2db4]]/T;
G = G(:,find(isnan(infoz.parms)));