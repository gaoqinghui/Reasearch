function [mlop,mna,output]=hj(R,mbar,d,nadum,plotdum,nlags)
%
% function [mlop,mna,output]=hj(R,mbar,d,nadum,plotdum)
%
% Calculates LOP and NA pricing kernels given gross returns R.  Does
% either HJ bounds problem or HJ distance problem.
%    For bounds, pass vector of mean pricing kernels as mbar and [] for d
%    For distance, pass vector of candidate SDF as d and [] as mbar.
%
%  INPUTS:
%              R         T x Nr matrix of gross returns.
%              mbar      N-vector of SDF means
%              d         Candidate SDF
%              nadum     1 does NA in addition to LOP, else just LOP
%              plotdum   Base fig # for plots. >0 does plot(s), else none.
%
%  OUTPUTS
%              mlop      T x N matrix of LOP SDFs
%              mna       T x N matrix of NA SDFs
%              output    HJ DIstance Estimate and Std Errors
%
%  NOTES:
%  * HJ bounds is same as distance with d as a vector of zeros.
%  * If R includes Rf, pass [] as mbar, otherwise, code augments R for you
%  * Supercedes programs KERNEL.M and HJDIST.M
%
%  VERSION 1.0.2 (7/10/01)

%  PROGRAMMER:   Mike Cliff,  Purdue Finance,  mcliff@mgmt.purdue.edu
%  WRITTEN:      10/4/00
%  MODIFIED	 1/24/01 Modified nwse function.
%                1/29/01 Figure number control
%                7/10/01 Use LOP solution for NA if LOP > 0  
%%%%		 9/19/07 Changed prt fid to use /dev/null

% --- Check Input Arguments ----------------------------------------------
[T,Nr] = size(R);
if nargin < 6
  nlags = floor(T^(1/3));                     % Lags in NW Std Errors
end
disp([int2str(nlags) ' Lags in Newey-West Standard Errors']);
if ~isempty(mbar) & ~isempty(d)
  error('Please enter either mbar (for HJ Bound) or d (for HJ Dist).')
end
if isempty(mbar)
  N = 1;
  rfdum = 0;
else
  N = rows(mbar);
  rfdum = 1;
end
if isempty(d)
  distdum = 0;
  d = zeros(T,1);
else
  distdum = 1;
  mbar = mean(d);
end
if isempty(nadum),   nadum = 0;         end
if isempty(plotdum), plotdum = 1;       end

% --- Initializations ----------------------------------------------------
iota = ones(T,1);
mna = repmat(NaN,T,N);
output = repmat(NaN,2,2);
Rin = R;

%=========================================================================
%  LOP BOUND: ANALYTICAL SOLUTION
%=========================================================================
Rbar = mean(R)';
dbar = mean(d);
Sigi = (R'*R/T - Rbar*Rbar')\eye(Nr);
Rdev = R - repmat(Rbar',T,1);
if distdum == 0
  mlop = repmat(mbar',T,1) + Rdev*Sigi*(1-Rbar*mbar');
else
  lambda = ((R'*R/T)\eye(Nr))*(R'*d/T - 1);  
  mlop = d - R*lambda;
  dist = sqrt(lambda'*R'*R/T*lambda);
  u = d.^2 - (d - R*lambda).^2 - 2*lambda'*ones(Nr,1);
  [junk,s2]=nwse(u-dist^2,ones(T,1),nlags);
  distse = sqrt(s2/T)/(2*dist);
  output(1,:) = [dist  distse];
end
  
    
%=========================================================================
%  NA BOUND: GMM ESTIMATE
%  SDF is max(d - R*lambda,0)
%  Uses moments E[sdf*R - 1] = 0
%=========================================================================

% --- GMM Settings -------------------------------------------------------
gmmopt.infoz.momt = 'hjm';
gmmopt.plot = 0;                      gmmopt.infoz.prt = 0;
gmmopt.prt = fopen('/dev/null');
gmmopt.infoz.nadum = nadum;           gmmopt.lags = nlags;

% --- Loop Over each mbar(i), estimate via GMM ---------------------------
if nadum == 1
  bin =  -(Rin'*Rin/T)\eye(Nr)*ones(Nr,1);
%    bin = ((Rin'*Rin)\eye(Nr))*Rin'*(d-mlop(:,i));
  if rfdum == 1
    bin = [0; bin];    
  end
  for i = 1:N
    fprintf(1,'\nNA Iteration %2d of %2d',i,N);
    if version < 6, flopsin = flops; end
    if rfdum == 1
      R = [iota/mbar(i) Rin];
    end
    if min(mlop(:,i)) < 0
      prc = ones(T,Nr+rfdum);
      gmmout = gmm(bin,gmmopt,prc,[d R],iota);
      mna(:,i) = max(d - R*gmmout.b,0);
      bin = gmmout.b;    
    else
      mna(:,i) = mlop(:,i);
    end
      
% --- Do HJ Dist If Needed -----------------------------------------------
    if distdum == 1
      if min(mlop(:,i)) < 0
	u = d.^2 - mna(:,i).^2 - 2*prc*gmmout.b;
	dist = sqrt(mean(u));

% --- Get SE(dist) using Delta Method ------------------------------------
%        grad = mean(prc - R.*repmat(mna(:,i),1,Nr+rfdum))/dist;
%        se = sqrt(grad*gmmout.bcov*grad');

% --- Get SE(dist) by Asymptotic Dist ------------------------------------   
        [junk,s2]=nwse(u-dist^2,ones(T,1),nlags);
	distse = sqrt(s2/T)/(2*dist);
      end
      output(2,:) = [dist distse];
    end
    if version < 6
      fprintf(1,'\t %7.2f Megaflops',(flops-flopsin)/1000000);  
    end
  end
end
fprintf('\n');

%========================================================================
%   PLOT RESULTS
%========================================================================
if plotdum > 0
  figure(plotdum)
  clf
  if distdum == 0                          % Do HJ Bound Plot
    plot(mbar,std(mlop)','b-')
    if nadum == 1
      hold on
      plot(mbar,std(mna)','r--');
    end
    title('HANSEN-JAGANNATHAN BOUND')
    xlabel('Mean of Pricing Kernel')
    ylabel('Std Dev of Pricing Kernel')
  else                                    % Do HJ Dist Plot 
    for i = 0:nadum
      if i == 0
	plot(d,[mlop-d],'o');
	hold on
	plot([min(d) max(d)],[0 0],'r:')
	msg = 'LOP';
      else
	figure(plotdum+1)
	clf
	plot(d,[mna-d],'o');
	hold on
	plot([min(d) max(d)],[0 0],'r:')
	msg = 'NA';
      end
	title(strvcat(['  HJ Distance: ' msg ' Kernel  '],...
	['\delta = ' num2str(output(i+1,1),'%7.4f') ...
	 '  se = ' num2str(output(i+1,2),'%7.4f')]))
      xlabel('Candidate (Model) SDF')
      ylabel('Adjustment to Make SDF Valid')
    end
  end
end
