% Demo using a user's weighting matrix

% --- Set up the Data ------------------------------------------------
randn('state',0);   % Use same seed for random number generator
X = [ones(1000,1) randn(1000,1) randn(1000,1)];
b = [0;1;-.1];
e = randn(1000,1);
y = X*b + e;

% --- Set up GMM options ---------------------------------------------
clear gmmopt
gmmopt.infoz.momt='lingmmm';
gmmopt.infoz.jake='lingmmj';
gmmopt.infoz.hess='lingmmh';
gmmopt.S='W';
gmmopt.W0='Z';
gmmopt.W='S';
b0=[0;0;0];

% --- Estimate First with W0=I, W=spectral density -------------------
disp('Pay attention to how the weights on the moments change.')
disp('Estimate with W0=I, W=S (spectral density)')
uout=gmm(b0,gmmopt,y,X,X);

% --- Now use a fixed W initially ------------------------------------
disp('Stike a key to continue'); pause
disp('Now use a fixed W initially, , W=S (spectral density)')
W0 = eye(3);  W0(1,1) = 1000;
gmmopt.W0='Win'
uout=gmm(b0,gmmopt,y,X,X,W0);

% --- Now use a W0=I, then user's W later -----------------------------
disp('Stike a key to continue'); pause
disp('Now use W0=Im then W based on userw.m')
gmmopt.W0='Z';
gmmopt.W='userw';
uout=gmm(b0,gmmopt,y,X,X);

% --- Now use user's W at all iterations -----------------------------
disp('Stike a key to continue'); pause
disp('Now use W from userw.m at all iterations')
gmmopt.W0='Z';
gmmopt.W='userw';
uout=gmm(b0,gmmopt,y,X,X);


