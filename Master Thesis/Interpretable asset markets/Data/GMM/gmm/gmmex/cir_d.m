% CIR_D
%
% GMM demo using Cox, Ingersoll, Ross (CIR) model
% 
% Written by: Jean Francois Drainville
% Modified by: Mike Cliff,  Purdue Finance,  mcliff@mgmt.purdue.edu
%       [minor modifications and changed to English from French]

% The continuous time model is stated as
%    dr = kappa(theta - r)dt + sigma*sqrt(r)*dZ
%
% so
%   E]dr| = kappa(theta - r)dt
%   Var[dr] = sigma^2*r
%
% A discrete time approximation is
%    r(t) - r(t-1) = kappa(theta - r) + e(t)
% or
%     y(t) = a + b*r(t-1) + e(t)
% so
%     y(t) - a - b*r(t-1)
%     [y(t) - a - b*r(t-1)]^2 - sigma^2 r
%
%  Moment conditions are these last two equations, times the instruments, 
%  which are a 1 and r(t-1).


% --- Initializations ----------------------------------------------------
cir_ddata				% Load Data
nz = 1;     				% Number of lags as instruments
T = rows(rawdata)-nz; 		      	% nb. obs.
X = rawdata(1:T,:);	  	        % Rt
y = rawdata(1+nz:end,:) - X; 		% Rt+1 - Rt
Z = [ones(T,1) X];                      % Instruments

% --- GMM Options -------------------------------------------------------
gmmopt.infoz.momt='cir_dm';		% Moment Conditions
gmmopt.infoz.jake='cir_dj';		% Jacobian of Moments
gmmopt.lags=7;	   			% Lags in weighting matrix
gmmopt.vname = strvcat('alpha','beta','var');	% variable names
b=[.02;-.3;0.11^2];			% Parameter Starting Values
gmmopt.null = [.0175;-.35;.02^2]	% Null hypothesis
gmmopt.infoz

disp('These are the gmmopt and infoz structures.');
disp('Strike a key to Start Estimation.');
pause;

% --- Estimate the model with gmm() -------------------------------------
gout=gmm(b,gmmopt,y,X,Z);
kappa = -gout.b(2);
theta = gout.b(1)/kappa;
fprintf(1,'Long-run mean, theta=%7.4f\n',theta);
fprintf(1,'Speed of adj,  kappa=%7.4f\n',kappa);
fprintf(1,'Volatility parm, sigma=%7.4f\n',sqrt(gout.b(3)));



% --- Draws Objective Function ------------------------------------------
pltindx = [2 3];
pltrange = repmat(gout.b(pltindx),1,2).*[.9 1.1; .9 1.1];
objplot(gmmopt.infoz,y,X,Z,gout.W,gout.b,pltindx,pltrange(1,:),...
  pltrange(2,:),gmmopt.vname(pltindx,:));
figure(1)
view(30,30)


