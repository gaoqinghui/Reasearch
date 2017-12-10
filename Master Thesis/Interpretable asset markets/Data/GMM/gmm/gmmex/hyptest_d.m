% Demo of Hypothesis Testing

% --- Set up the Data ------------------------------------------------
randn('state',0);   % Use same seed for random number generator
X = [ones(1000,1) randn(1000,1) randn(1000,1)];
b = [0;1;-.1];
e = randn(1000,1);
y = X*b + e;

% --- Set up the GMM Options -----------------------------------------
clear gmmopt
gmmopt.infoz.momt='lingmmm';
gmmopt.infoz.jake='lingmmj';
gmmopt.infoz.hess='lingmmh';
gmmopt.S='W';
bu=[0;0;0];
br=[0;0];

% --- Estimate Unconstrained for LR ----------------------------------
disp('Estimate the Unconstrained Model')
disp('uout=gmm(bu,gmmopt,y,X,X);')
uout=gmm(bu,gmmopt,y,X,X);

% --- Estimate Constrained for LR (same W) ---------------------------
disp('Strike A Key to Continue'); pause
disp('Estimate the Constrained Model on the Prior W');
disp('W0 = uout.W;  gmmopt.W0 = ''Win'';');
disp('rout=gmm(br,gmmopt,y,X(:,1:2),X,W0);');
disp('LR = rout.nobs*(rout.f - uout.f);');
W0 = uout.W;
gmmopt.W0 = 'Win';
rout=gmm(br,gmmopt,y,X(:,1:2),X,W0);
LR = rout.nobs*(rout.f - uout.f);

% --- Do Wald Test from Unconstrained Estimates -----------------------
disp('Strike A Key to Continue'); pause
disp('Wald Test Using Unconstrained Estimates')
disp('R = [0 0 1]; r = 0;');
disp('W = (R*uout.b - r)'',*inv(R*uout.bcov*R'')*(R*uout.b - r);');
R = [0 0 1];
r = 0;
W = (R*uout.b - r)'*inv(R*uout.bcov*R')*(R*uout.b - r);

% --- Estimate Constrained for W (normal W) --------------------------
disp('Strike A Key to Continue'); pause
disp('Estimate the Constrained Model on the Normal W');
disp('gmmopt.W0=''Z'';');
disp('rout=gmm(br,gmmopt,y,X(:,1:2),X);');
disp('Wr = rout.W;');
gmmopt.W0='Z';
rout=gmm(br,gmmopt,y,X(:,1:2),X);
Wr = rout.W;

% --- Do LM Test ------------------------------------------------------
disp('Strike A Key to Continue'); pause
disp('Evaluate the Unconstrained Obj function at the Constained Estimate');
disp('See the file hyptest.m for the code to do this test.')
gmmopt.infoz.call = 'gmm';
lmb = [rout.b; 0];                   % Construct restr version of full b
momt = fcnchk(gmmopt.infoz.momt);
jake = fcnchk(gmmopt.infoz.jake);
m = feval(momt,lmb,gmmopt.infoz,[],y,X,X);   % Reeval moment conditions
M = feval(jake,lmb,gmmopt.infoz,[],y,X,X);   % Reeval Jacobian 
term1 = M'*Wr*m; 
term2 = (M'*Wr*M)\eye(uout.nvar);
LM = rout.nobs*term1'*term2*term1;

% --- Estimate by OLS with White SEs for Comparison ------------------
disp('Strike A Key to Continue'); pause
disp('Estimate by OLS with White SEs');
olsout = hwhite(y,X);
prt(olsout);

out = [olsout.tstat(3)^2; W; LR; LM];
out = [out 1-chi2cdf(out,1)];
out = [olsout.tstat(3) olsout.tprob(3); out];
in.rnames = strvcat('Test Stat','p-value');
in.cnames = strvcat('t','t^2','Wald','LR','LM');
disp(' ');
disp('Comparison of Test Statistics');
mprint1(out',in);
