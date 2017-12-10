function ckls_d()
% CKLS_D
%
% GMM demo using  Chan, Karolyi, Longstaff and Sanders (JF, 1992)
% 
% Written by: Mike Cliff,  Purdue Finance,  mcliff@mgmt.purdue.edu
%       [modified from a CIR program by Jean Francois Drainville]

% The continuous time model is stated as
%    dr = kappa(theta - r)dt + sigma*r^gamma*dZ
%
% so
%   E[dr] = kappa(theta - r)dt
%   Var[dr] = sigma^2*r^(2*gamma)dt
%
% A discrete time (monthly) approximation is
%    r(t) - r(t-1) = kappa[theta - r(t-1)]*[t - (t-1)] + e(t)
% or
%     y(t) = (a + b*r(t-1))/12 + e(t)
% so
%     e1(t) = y(t) - (a + b*r(t-1))/12
%     e2(t) = e1(t)^2 - sigma^2 r^(2*gamma)/12
%
%  Moment conditions are these last two equations, times the instruments, 
%  which are a 1 and r(t-1).


% --- Initializations ----------------------------------------------------
load ckls.dat				% Load Data
T = rows(ckls)-1;			% nb. obs.
r = ckls(1:T,3)/100;			% Rt
dr = ckls(2:end,3)/100-r;		% Rt+1 - Rt
Z = [ones(T,1) r];			% Instruments
b0=[mean(r); 0; 12*var(dr)/var(r); .5];	% Parameter Starting Values
null = [0 0 0 .5]';			% Null hypothesis
vname = strvcat('alpha','beta','sigma^2','gamma');	% Names


% --- Print Summary Stats -----------------------------------------------
in.rnames = strvcat('Mean','Std',[repmat('Rho_',6,1) int2str([1:6]')]);
in.cnames = strvcat('r(t)','r(t)-r(t-1)');
mprint1([mean([r dr]); std([r dr]); autocorr([r dr],6)],in);

% --- GMM Options -------------------------------------------------------
gmmopt.W0='Z';				% Initial Weighting Matrix
gmmopt.infoz.hess = 'gn';		% Search Direction
gmmopt.infoz.momt='ckls_dm';		% Moment Conditions
gmmopt.infoz.jake='ckls_dj';		% Jacobian of Moments
gmmopt.lags=7;	   			% Lags in weighting matrix
gmmopt.vname = vname;
gmmopt.null = null;
gmmopt.infoz.parms = [NaN NaN NaN NaN]'; % Special field used by ckls_dm
gmmopt.infoz
disp('These are the gmmopt and infoz structures.');
disp('Strike a key to Start Estimation.');
pause;

% --- Estimate the Full model with gmm() --------------------------------
gout=gmm(b0,gmmopt,dr,r,Z);
condvar0 = ckls_info(gout,repmat(NaN,4,1),vname,dr,r);

% --- Draws Objective Function ------------------------------------------
pltindx = [3 4];
pltrange = repmat(gout.b(pltindx),1,2).*[.9 1.1; .9 1.1];
objplot(gmmopt.infoz,dr,r,Z,gout.W,gout.b,pltindx,pltrange(1,:),...
	pltrange(2,:),gmmopt.vname(pltindx,:));
figure(1), view(30,30)
disp('Full Model Estimation Complete. Strike a key to Start CIR Estimation.');
pause;


% --- Estimate the CIR model with gmm() --------------------------------
parms = [NaN NaN NaN .5]';		% Specify Restriction
[bin, opt] = ckls_prep(parms,b0,gmmopt,null,vname);
gout=gmm(bin,opt,dr,r,Z);
condvar = ckls_info(gout,parms,vname,dr,r);

% --- Plot Conditional Variance ----------------------------------------
figure(3), clf, hold on
xax = [eomdate(1964,6):eomdate(1989,10)]';
xax = unique(eomdate(year(xax),month(xax)));
plot(xax,abs(dr),'b:')
plot(xax,sqrt(condvar0),'r-',xax,sqrt(condvar),'g--','LineWidth',2)
dateaxis('x',12)
ylabel('Conditional Volatility')
legend('|r(t)-r(t-1)|','Full Model','CIR Model')
disp('CIR Model Estimation Complete. Strike a key to Estimate All Models.');
pause;


% --- Estimate Nine Nested Models -------------------------------------
gmmopt.prt = 0;
gmmopt.infoz.prt = 0;
gmmopt.plot = 0;
Plist = strvcat('Full','Merton','Vasicek','CIR SR','Dothan','GBM',...
	 'Brennan-Schwarz','CIR VR','CEV');
Parms = repmat(NaN,9,4);
out1 = Parms;
out2 = out1;
out3 = repmat(NaN,9,5);
Parms(2,[2 4]) = [0 0];		% Merton
Parms(3,4) = 0;			% Vasicek
Parms(4,4) = 0.5;		% CIR SR
Parms(5,[1 2 4]) = [0 0 1];	% Dothan
Parms(6,[1 4]) = [0 1];		% GBM
Parms(7,4) = 1;			% Brennan-Schwartz
Parms(8,[1 2 4]) = [0 0 1.5];	% CIR VR
Parms(9,1) = 0;			% CEV

for i = 1:rows(Parms)
  fprintf(1,'%s\n',Plist(i,:));
  [bin, opt] = ckls_prep(Parms(i,:)',b0,gmmopt,null,vname);
  gout=gmm(bin,opt,dr,r,Z);
  [condvar,temp] = ckls_info(gout,Parms(i,:)',vname,dr,r);
  out1(i,:) = temp(1,1:4);
  out2(i,:) = temp(2,1:4);
  out3(i,:) = [temp(1,5) temp(2,5) temp(1,6:end)];
end

rnames = Plist;
fprintf('\t\t  alpha\t\t  beta\t\t Sigma^2\t gamma\n');
for i = 1:rows(Plist)
  fprintf('%s\t',rnames(i,:));
  fprintf(' %7.4f \t %7.4f \t %7.4f \t %7.4f \n',out1(i,:));
  s = sprintf('(%7.4f)\t(%7.4f)\t(%7.4f)\t(%7.4f)\n',out2(i,:));
  s = strrep(s,'(    NaN)','         ');
  fprintf('\t\t%s\n',s);
end
in.rnames = rnames;
in.cnames = strvcat('J_T','p-value','df','R^2_1','R^2_2');
in.fmt = strvcat('%7.4f','%7.4f','%1d','%7.4f','%7.4f');
mprint1(out3,in);



%=====================================================================
%	HELPER FUNCTIONS
%=====================================================================

function [bin,opt] = ckls_prep(parms,b0,opt,null,vname)
% --- Prepare starting values and options structure -----------------
  opt.vname = vname(isnan(parms),:);
  opt.null = null(isnan(parms));
  opt.infoz.parms = parms;
  bin = b0(isnan(parms));

function [condvar, out] = ckls_info(gout,parms,vname,y,X)
% --- Print Some Info on the Results --------------------------------

  b = repmat(NaN,4,1);
  b(isnan(parms)) = gout.b;
  b(~isnan(parms)) = parms(~isnan(parms));
  alpha = b(1);
  beta  = b(2);
  sigsq = b(3);
  gamma = b(4);
  kappa = -beta;
  theta = alpha/kappa;
  condvar = sigsq*X.^(2*gamma)/12;
  yhat = (alpha+beta*X)/12;
  rsq1 = var(yhat)/var(y);
  rsq2 = var(condvar)/var(y.^2);
  if min(isnan(parms)) == 0
    fprintf(1,'Constraints:');
    indx = find(~isnan(parms));
    for i = 1:rows(indx)
      fprintf(1,'\t%s=%7.4f',deblank(vname(indx(i),:)),b(indx(i)));
    end
  end  
  fprintf(1,'\nLong-run mean,    theta = %6.4f%%\n',theta*100);
  fprintf(1,'Speed of adj,     kappa = %6.4f\n',kappa);
  fprintf(1,'Volatility parm,  sigma = %6.4f\n',sqrt(sigsq));
  fprintf(1,'Cond. Vol. parm,  gamma = %6.4f\n',gamma);
  fprintf(1,'Average Cond Volatility = %6.4f%%\n',mean(sqrt(condvar))*100);
  fprintf(1,'R^2 (yld change)   = %6.4f\n',rsq1);
  fprintf(1,'R^2 (sqrd yld chg) = %6.4f\n\n\n\',rsq2);
  out = [alpha beta sigsq gamma gout.J gout.df rsq1 rsq2; ...
	 repmat(NaN,1,8)];
  out(2,find(isnan(parms))) = gout.se';
  out(2,5) = gout.p;