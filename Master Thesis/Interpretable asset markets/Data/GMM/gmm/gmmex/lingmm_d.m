% LINGMM_D  Demo program for GMM estimation of a  linear model
randn('state',0);   % Use same seed for random number generator
disp('Demo program for GMM estimation of a  linear model')
disp('The model is y = X*b with b=[0;1;-1]')
disp('We will generate some data, estimate by OLS (using White SE), then')
disp('estimate by GMM and compare.')

X = [ones(1000,1) randn(1000,1) randn(1000,1)];
b = [0;1;-1];
e = randn(1000,1);
y = X*b + e;

olsout=hwhite(y,X);
prt_reg(olsout);

disp('Strike a key to continue')
pause


disp(' Now we define a structure variable to tell GMM what to do.')
clear gmmopt
gmmopt.infoz.momt='lingmmm';
gmmopt.infoz.jake='lingmmj';
gmmopt.infoz.hess='lingmmh';
gmmopt.infoz.step='step2';
gmmopt.prt=1;
gmmopt.infoz.prt=1;
gmmopt.gmmit = 1;
gmmopt.S='W'
disp('gmmopt.infoz is')
disp(gmmopt.infoz)

disp('We have specified the moment conditions, derivative of the moment ')
disp('conditions (Jacobian), and the spectral density matrix (White).')
disp('We will use the optimal weighting matrix (inverse of spectral ')
disp('density matrix) by default. Since the model is linear in parameters,')
disp('the analytic Hessian is available.')
disp(' ')
disp('GMM knows to form the quadratic m''Wm')
disp('We need some starting values b0=zeros(3,1)')
b0=zeros(3,1);

disp('Strike a key to start the estimation')
pause

gmmout=gmm(b0,gmmopt,y,X,X);

prt_reg(olsout);
disp('Strike a key to continue')
pause

disp('Now try using some other Hessian: ')
disp(' 1 = Steepest Descent')
disp(' 2 = Gauss Newton')
disp(' 3 = Levenberg-Marquardt')
disp(' 4 = DFP')
disp(' 5 = BFGS')
htype=input('Enter the number for your selection. ');
if htype == 1, gmmopt.infoz.hess='sd';
elseif htype == 2, gmmopt.infoz.hess='gn';
elseif htype == 3, gmmopt.infoz.hess='marq';
elseif htype == 4, gmmopt.infoz.hess='dfp';
else gmmopt.infoz.hess='bfgs'; end
gmmout=gmm(b0,gmmopt,y,X,X);
prt_reg(olsout);

%clear X b b0 e gmmopt gmmout htype olsout y
