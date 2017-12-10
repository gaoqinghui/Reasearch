function [gmmout,dist,m1,m2]=hjshift(R1,R2,mu,nadum,fid)
%
% function [gmmout,dist,m1,m2]=hjshift(R1,R2,mu,nadum,fid)
%
% HJSHIFT  Test for upward shift in HJ bound upon addition of new assets
%          Supports LOP and NA measure, will draw a picture. 
%  
%  R1    (T x k) matrix of gross returns on basis assets 
%  R2    (T x N) matrix of gross returns on test assets   
%  mu    2-vector of SDF means.  mean(mu) is used to measure distance
%  nadum =1 does NA measure, else LOP
%  fid   Tell what to do with output.  Set 0 to suppress. 
%
%  Note: User may want to change range of E[m]'s or GMM options
%  Program KZ span is a more recent version.  It is cleaner and does more 
%  tests, but does not do NA kernels.  User should be ware because there
%  are some differences in answers from the two programs.
  
% WRITTEN BY:  Mike Cliff,  Purdue Finance,  mcliff@mgmt.purdue.edu
% CREATED:     10/12/00

  
% --- Initializations ------------------------------------------------
mbar = [.98:.005:1.02]';        % Can Change if needed for your dataset

if nargin == 4
  fid = 1;
end
T = rows(R1);
iota = ones(T,1);
%R1 = [iota R1];
n = cols(R1);
k = cols(R2);


% --- Set Up GMM Stuff -----------------------------------------------
gmmopt.infoz.momt='hjshiftm';
gmmopt.S='NW';
gmmopt.infoz.hess='gn';      % Hessian method.  GN is fast but less robust
gmmopt.infoz.mu = mu;
gmmopt.infoz.nadum = nadum;
gmmopt.prt = 1;
gmmopt.gmmit = 1;
if fid == 0
  gmmopt.plot = 0;
end


% --- Get Starting Values ---------------------------------------------
R = [R1 R2];
%%cov1 = cov(R1);
%%cov12 = cov(R);
%%R1e = R1 - repmat(mean(R1),T,1);
%%R2e = R2 - repmat(mean(R2),T,1);
%%Re = [R1e R2e];
%%bin1 = mu(1) + R1e*inv(cov1)*(ones(k,1) - mean(R1)'*mu(1);

%bin0 = ((R1'*R/T * R'*R1/T)\eye(k))*(R1'*R/T);  
%bin1 = bin0*(ones(cols(R),1) - mu(1)*mean(R)');
%bin2 = bin0*(ones(cols(R),1) - mu(2)*mean(R)');

%bin0 = (cov(R1)\eye(n)); 
Sigi = (R'*R/T)\eye(n+k);
rbar = mean(R)';
c1 = (mu(1) - rbar'*Sigi*ones(n+k,1))/(1-rbar'*Sigi*rbar)
c2 = (mu(2) - rbar'*Sigi*ones(n+k,1))/(1-rbar'*Sigi*rbar)
bin1 = Sigi*(ones(n+k,1) - c1*rbar);
bin2 = Sigi*(ones(n+k,1) - c2*rbar);
bin = [c1; bin1; c2; bin2];
bin = [bin1; bin2];

sdf1 = c1 + R*bin1;
sdf2 = c2 + R*bin2;
[mean(sdf1) mean(sdf2)]
[R'*sdf1/T R'*sdf2/T]

% --- Estimate via GMM -----------------------------------------------
gmmout = gmm(bin,gmmopt,R2,R1,iota);
A = [zeros(n,k) eye(n) zeros(n,n+k);
    zeros(n,n+k) zeros(n,k) eye(n)];
W = (A*gmmout.b)'*inv(A*gmmout.bcov*A')*(A*gmmout.b);
p = 1 - chi2cdf(W,2*n);

Re = R - repmat(mean(R),T,1);
sdf1 = mu(1) + Re*gmmout.b(1:n+k);
sdf2 = mu(2) + Re*gmmout.b(n+k+1:end);
disp('Price of Assets')
R'*[sdf1 sdf2]/T
disp('Mean of SDFs')
[mean(sdf1) mean(sdf2)]

% --- Find Bounds and Calculate Distance -----------------------------
mbar = [mu; mbar];
mbar = unique(mbar);
indx(1) = find(mbar==mu(1));
indx(2) = find(mbar==mu(2));
[mlop1,mna1] = hj(R1,mbar,[],nadum,0);
[mlop2,mna2] = hj([R1 R2],mbar,[],nadum,0);

% --- Plot the Bounds ------------------------------------------------
if nadum == 1
  m1 = mna1;
  m2 = mna2;
else
  m1 = mlop1;
  m2 = mlop2;
end
sd1 = std(m1);
sd2 = std(m2);
dist = [sd2(indx) - sd1(indx)]';

if fid >= 0
  figure(50)
  clf
  plot(mbar,sd1,'b-',mbar,sd2,'r--')
  hold on
  plot(mu,sd1(indx),'bo','MarkerSize',4)
  plot(mu,sd2(indx),'ro','MarkerSize',4) 
  xlabel('Mean of SDF')
  xlabel('Std Dev SDF')
  title('SHIFT IN HJ BOUND')
  fprintf(fid,'\nDistance Between Bounds = %7.4f  [E(m)=%7.4f]',...
	  [dist mu]');
  fprintf(fid,'\nW(%d) = %7.4f    p-value = %7.4f\n',2*n,W,p);
end