% GMM_D  A Demo of the GMM program

%==========================================================================
%   WRITE A DESCRIPTION OF THE PROBLEM
%==========================================================================

disp('---------------------------------------------------------------------')
disp('GMM Demo:  Application is (nonlinear) Asset Pricing Test')
disp(' The economic structure is E[Rm] = 1')
disp('  R is a NxT matrix of returns, N assets, T dates')
disp('  m is the Intertemporal Marginal Rate of Substitution (IMRS)')
disp('  it is a discount rate that makes the price of the asset 1')
disp('  It is T-dimensional vector.')
disp(' ')
disp('The model for m is m = b(1)*cg^(-b(2))')
disp('  b(1) is an impatience parameter')
disp('  b(2) is the risk aversion parameter (>0)')
disp('  cg is the consumption growth rate c_t/c_(t-1)')
disp(' The returns are real value-weighted market return and T-bill')
disp(' For instruments we will use lagged values of R and cg and a constant')
disp('---------------------------------------------------------------------')
disp(' ')
disp('Hit a key to continue')
pause

%==========================================================================
%  READ IN DATA AND INITIALIZATIONS
%==========================================================================

gmmdata                             % Sample data from Ogaki
rawdata = rawdata(1:330,:);         % The last few obs are weird
nz = 1;                             % Number of lags used as instruments
T = rows(rawdata)-nz;
neq = cols(rawdata)-1;

cg = rawdata(1+nz:T+nz,1);
R = rawdata(1+nz:T+nz,2:3);

y = ones(T,neq);
X = [cg R];
Z = ones(T,1);
for i = 1:nz
  Z = [Z rawdata(1+nz-i:T+nz-i,1:3)];
end


% --- Set GMM options ----------------------------------------------------
disp('---------------------------------------------------------------------')
disp(' We give GMM instructions through the gmmopt and infoz structures:')
disp(' We refernce the moment conditions and derivatives')
disp(' and specify a Newey-West weighting matrix with 12 lags')
disp(' Starting values are b(1)=.98 and b(2) = 4')

infoz.momt='gmmexm';			% moment conditions
infoz.jake='gmmexj';			% Deriv of moment cond.
infoz.step='step2';			% Step length algorithm
infoz.hess='bfgs'			% Hessian (search direction)
gmmopt.infoz = infoz;
gmmopt.gmmit = 2;			% Number of GMM iterations
gmmopt.W0 = 'Z';			% Initial weighting matrix
gmmopt.W='S';				% Subsequent wtg matrix optimal
gmmopt.S='NW';				% Select subsequent wtg matrix
%gmmopt.wtvec=[0 0 1]';
gmmopt.lags=12;				% Lags in weighting matrix
gmmopt.prt=1				% Control printing
gmmopt.vname = strvcat('beta','gamma');	% variable names
b=[.98;5];				% Starting values
gmmopt.null = [1;0];			% Null hypothesis

disp('Hit a key to begin the estimation')
pause

% --- Estimate the model with gmm() -------------------------------------
gout=gmm(b,gmmopt,y,X,Z);

% --- Draws Objective Function ------------------------------------------
objplot(gmmopt.infoz,y,X,Z,gout.W,gout.b,[1 2],[.9 1.1],...
  [0 3],gmmopt.vname);
figure(1)
view(110,30)
