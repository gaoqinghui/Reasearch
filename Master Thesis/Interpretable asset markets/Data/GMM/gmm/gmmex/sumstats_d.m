% SUMSTATS_D.M
%
% Deom to find Means, Variances, and Covariances from a dataset Y using
% GMM.

disp('Demo to Calculate Summary Statistics with GMM')

T = 1000;
k = 3;
Y = randn(T,k);
disp('Simply Specify moments and jacobian')
gmmopt.infoz.momt='msdm';
gmmopt.infoz.jake='msdj'
bin = zeros(k + k*(k+1)/2,1);
disp('Do GMM with the code:')
disp('out = gmm(bin,gmmopt,Y,[],ones(T,1));')
out = gmm(bin,gmmopt,Y,[],ones(T,1));

disp('Note that the standard errors are calculated via Newey-West')
disp('Here are the parmeters calculated in the standard fashion:')
disp([mean(Y)'; vech(cov(Y))])
