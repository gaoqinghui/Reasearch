function W = userw(b,gmmopt,Y,X,Z);
%
%function W = userw(b,infoz,Y,X,Z);
%
% Function to calculate user-defined weighting matrix.  Example uses
% inverse of diagonal of cov (e.*Z)
  
momt = fcnchk(gmmopt.infoz.momt);
[m,e] = feval(momt,b,gmmopt.infoz,[],Y,X,Z);
u = repmat(e,1,cols(Z)).*Z;
S = diag(diag(cov(u)));
W = S\eye(cols(S));
