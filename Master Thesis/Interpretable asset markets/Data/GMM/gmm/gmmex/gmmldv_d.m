% GMMLDV_D
%
% Demo of Limited Dependent Variable Models in GMM.
% Use Spector and Mazzeo data from Greene (1997) Table 19.1
% Data is in file gmmldv.dat, contains [obs GPA TUCE PSI GRADE]
%
% GRADE is a 0/1 variable indicating if exposure to PSI improved test
% scores.  Other vars, plus a constant are explanatory vars.
%
% We estimate three models:
% 1) Linear probability Model
% 2) Logit Model
% 3) Probit Model
%
% Use ML scores as moments.  Jacobian is Hessian of log-likelihood.
% Interesting use of user-defined Spectral density matrix.


% --- Load Data ------------------------------------------------------
%readnameddata('gmmldv.dat');
load gmmldv
iota = ones(size(GRADE));
X = [iota GPA TUCE PSI];

% --- Initializations ------------------------------------------------
b0 = zeros(4,1);
clear opt in
opt.gmmit = 1;
opt.W0 = 'I';
opt.plot = 0;
opt.vname = strvcat('Const','GPA','TUCE','PSI');


% --- Linear Probability Model ---------------------------------------
opt.infoz.momt = 'lingmmm';
opt.infoz.jake = 'lingmmj';
opt.S = 'P';
out1 = gmm(b0,opt,GRADE,X,X);

% --- Logit Model ----------------------------------------------------
opt.infoz.momt = 'logitm';
opt.infoz.jake = 'logitj';
opt.S = 'logitS';
out2 = gmm(b0,opt,GRADE,X,X);

% --- Probit Model ---------------------------------------------------
opt.infoz.momt = 'probitm';
opt.infoz.jake = 'probitj';
opt.S = 'probitS';
out3 = gmm(b0,opt,GRADE,X,X);

% --- LeSage's Logit and Probit --------------------------------------
out4 = logit(GRADE,X);
out5 = probit(GRADE,X);


% --- Compute Marginal Effects at sample mean ------------------------
me1 = out1.b;
me2 = exp(mean(X)*out2.b)/(1+exp(mean(X)*out2.b));
me2 = me2*(1-me2)*out2.b;
me3 = normpdf(mean(X)*out3.b)*out3.b;

% --- Summarize the Results ------------------------------------------
in.rnames = opt.vname;
in.cnames = strvcat('Linear','Logit','Probit','Logit (ML)','Probit (ML)');
fprintf('Coefficient Estimates\n');
mprint1([out1.b out2.b out3.b out4.beta out5.beta],in);
fprintf('Standard Errors\n');
mprint1([out1.se out2.se out3.se out4.se out5.se],in);
fprintf('t-stat\n');
mprint1([out1.t out2.t out3.t out4.tstat out5.tstat],in);
fprintf('Marginal Effects\n');
mprint1([NaN NaN NaN; me1(2:end) me2(2:end) me3(2:end)],in);

xx = [1:rows(X)]';
P1 = X*out2.b;
P2 = exp(X*out2.b)./(1+exp(X*out2.b));
P3 = normcdf(X*out2.b);
plot(xx,GRADE,'*',xx,P1,'s',xx,P2,'o',xx,P3,'^')

C1 = zeros(size(P1));	C1(find(P1 >= .5)) = 1;
C2 = zeros(size(P2));	C2(find(P2 >= .5)) = 1;
C3 = zeros(size(P3));	C3(find(P3 >= .5)) = 1;

out = zeros(3,3,3);
C = [C1 C2 C3];
in.rnames = strvcat('GRADE=0','GRADE=1','Total');
in.cnames = strvcat('Pred=0','Pred=1','Total');
in.fmt = '%2d';
lab = strvcat('Linear','Logit','Probit');
for i = 1:3
  out(1,1,i) = rows(find(GRADE==0 & C(:,i)==0));
  out(1,2,i) = rows(find(GRADE==0 & C(:,i)==1));
  out(2,1,i) = rows(find(GRADE==1 & C(:,i)==0));
  out(2,2,i) = rows(find(GRADE==1 & C(:,i)==1));
  out(1,3,i) = rows(find(GRADE==0));
  out(2,3,i) = rows(find(GRADE==1));  
  out(3,3,i) = rows(GRADE);  
  out(3,1,i) = rows(find(C(:,i)==0));  
  out(3,2,i) = rows(find(C(:,i)==1)); 
  fprintf('Predicted vs Actual Results: %s Model\n',deblank(lab(i,:)));
  mprint1(out(:,:,i),in);
end
