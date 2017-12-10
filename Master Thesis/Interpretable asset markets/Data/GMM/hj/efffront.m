function [out, wts, g, h, tanstats]=efffront(mu,Sig,rf,names,plotdum)
% [out, wts, g, h, tanstats]=efffront(mu,Sig,rf,names,plotdum)
%
% EFFFRONT:  Plots the efficient frontier from a set of assets
%   mu     = N-vector of mean returns
%   Sigma  = Var-Cov matrix of asset returns
%   rf     = scalar riskless rate (optional, Use [] to skip)
%   names  = String structure of asset names (optional.  Use [] to skip)
%   plotdum  0 turns off plotting (optinal.  Plots on by default)
%
%   out      matrix of frontier means and standard deviations 
%   wts      asset weights for frontier portfolios
%   g, h     fundatemental portfolio weights such that
%              1'g = 1.0,   1'h = 0.0
%              mu'g = 0.0   mu'h = 1.0
%              w_p = g + h*mu_p  are weights to get return of mu_p 
%   tanstats [sig, mu] of tangency portfolio
%
%  NOTE: If the frontier on your graph is too big/small, change the
%  variables 'top' and 'bottom' at the beginning of the code.
  
% Written by:  Mike Cliff,  Purdue Finance,  mcliff@mgmt.purdue.edu
% UPDATED: 8/11/00 to allow inclusion of Rf & draw tangency
%          10/4/00, 11/2/00  better guess of range of frontier (top, below)  
%          1/29/01  Fix probs with tangency calc, alt. calc of bottom
%          7/6/01   plotdum controls plotting.  
%          4/3/03   fixed plotting of names w/ nargin==5
%	  10/30/03  return NaNs for tanstats if rf not used
%	   4/1/04   replaced i's with iotas.

%=========================================================================
%    INITIALIZATIONS
%=========================================================================

% --- Some control settings ----------------------------------------------
nport = 25;   % Number of frontier portfolios
out = zeros(nport,2);
wts = zeros(rows(mu),nport);
bottom = .9;   % Factor to control minimum E(R) 
corrout = Sig./(sqrt(diag(Sig))*sqrt(diag(Sig))');
top = 1 + 2/mean(mean(corrout));    % Factor to control maximum E(R)
top = max(mu)*top;
bottom = min(mu)*bottom;

% --- Alternative lower point: see Cochrane AP text ---------------------
%Sigi = Sig\eye(cols(Sig));
%R2i = (Sig + (1+mu)*(1+mu)')\eye(cols(Sig));
%bottom = sum(R2i*(1+mu));
%bottom = bottom/(sum(sum(R2i*Sig*R2i))+bottom^2) - 1;

if nargin >= 3
  if isempty(rf)
    dotan = 0;
    rf = NaN;
  else
    dotan = 1;
  end  
  if nargin < 5
    plotdum = 1;
  end  
else
  rf = NaN;
  dotan = 0;
  plotdum = 1;
end
if min(mu>1), error('Please use net returns in EFFFRONT'); end


% --- Optimization Problem ----------------------------------------------
%
% L = .5w'Sigma w + lambda(mup - w'mu) + gamma(1 - w'iota)
%    FOC   Sigma w = lambda mu + gamma iota
%          mup = w'mu, 1 = w'iota
% ==>  w = lambda Sigma^-1 mu + gamma Sigma^-1 iota
%          iota'w = lambda A + gamma C = 1
%          mu'w = lambda B + gamma A = mup
% ==> lambda = (C mup - A)/D,  gamma = (B - A mup)/D
%          g = (B Sigma^-1 iota - A Sigma^-1 mu)/D
%          h = (C Sigma^-1 mu - A Sigma^-1 iota)/D
% ==> w = g  + h mup

Sigi=Sig\eye(rows(Sig));
iota=ones(rows(mu),1);
A=mu'*Sigi*iota;
B=mu'*Sigi*mu;
C=iota'*Sigi*iota;
D=B*C-A^2;

%=========================================================================
%   Find Tangency Portfolio, if given Rf
%   Pick two frontier portfolios, a and b
%=========================================================================
g = (B*Sigi*iota - A*Sigi*mu)/D;
h = (C*Sigi*mu - A*Sigi*iota)/D;
a = g + h*(A/C);             % Pf a is Global Min Var Pf
b = g + h*out(end,2);        % Pf b has mean of last Pf on frontier

if (mu'*a < rf)
  warning('Given Rf higher than MVP, Using MVP. Lower Rf if you want.');
  rf = A/C;
end  


if dotan == 1
  if rf > A/C
    exret_a = mu'*a - rf;
    exret_b = mu'*b - rf;
    var_a = a'*Sig*a;
    var_b = b'*Sig*b;
    cov_ab = a'*Sig*b;
    num = exret_a*var_b - exret_b*cov_ab;
    den = exret_a*var_b + exret_b*var_a + (exret_a-exret_b)*cov_ab;
    w_t = Sigi*(mu-rf)/(A-C*rf);
  else
    w_t = Sigi*(mu-rf);
    w_t = w_t/sum(w_t);
  end  
  tanstats = [sqrt(w_t'*Sig*w_t) w_t'*mu];
  SR = (tanstats(2)-rf)/tanstats(1);
  top = max(top,max(tanstats(:,2)));
  bottom = min(bottom,min(tanstats(:,2)));
else
  tanstats = [NaN NaN];
end


% --- Find Mean-Std for Frontier Portfolios ------------------------------
mup=linspace(bottom,top,nport)';      %  Range of Means 
for n = 1:rows(mup)
  w = g + h*mup(n);
  wts(:,n) = w;
  Sigp=w'*Sig*w;
  out(n,:)=[sqrt(Sigp) mup(n)];
end



%=========================================================================
%  Generate plots
%=========================================================================

if plotdum == 1
  assets=[diag(Sig).^.5 mu];
  plot(assets(:,1),assets(:,2),'r+')   % Plot individual assets
  hold on
  if dotan == 1
    plot([0; tanstats(1)],[rf; tanstats(2)],'ro')
    CML = rf + SR*[0; out(:,1)];
    plot([0; out(:,1)],CML,'r--');  
  end
  plot(out(:,1),out(:,2))              % Plot frontier
  title('Efficient Frontier')
  ylabel('Expected Return')
  xlabel('Standard Deviation')
  
  
% --- Add asset names if available ---------------------------------------
  if  nargin >= 4
    axsize = axis;
    spc = .02*(axsize(2) - axsize(1));
    for ct = 1:rows(names)
      text(assets(ct,1)+spc,assets(ct,2),names(ct,:))
    end
    if dotan == 1
      text(tanstats(1)-spc,tanstats(2),'T')
      text(spc+spc,rf,'Rf')    
    end  
  end
  hold off
end