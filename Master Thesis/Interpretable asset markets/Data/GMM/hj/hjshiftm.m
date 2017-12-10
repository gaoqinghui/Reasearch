function [m,e] = hjshiftm(b,infoz,stat,y,x,z,w)
%
% function [m,e] = hjshiftm(b,infoz,stat,y,x,z,w)
%
% HJSHIFTM Moment conditions used by HJSHIFT
  
% WRITTEN BY:  Mike Cliff,  Purdue Finance,  mcliff@mgmt.purdue.edu
% CREATED:     10/12/00

  
T = rows(x);
iota = ones(T,1);
Npf = cols(x);
Ny = cols(y);

wts1 = b(1:Npf+Ny); 
wts2 = b(Npf+Ny+1:2*(Npf+Ny));
%xe = x - repmat(mean(x),T,1);
%ye = y - repmat(mean(y),T,1);
R = [x y];
Re = R - repmat(mean(R),T,1);        % Ignores sampling error in means
sdf1 = infoz.mu(1) + Re*wts1; 
sdf2 = infoz.mu(2) + Re*wts2;

%sdf1 = wts1(1) + [x y]*wts1(2:end); 
%sdf2 = wts2(1) + [x y]*wts2(2:end); 

if infoz.nadum == 1
  sdf1 = max(sdf1,zeros(T,1));
  sdf2 = max(sdf2,zeros(T,1));
end

e1 = [R.*repmat(sdf1,1,Npf+Ny) R.*repmat(sdf2,1,Npf+Ny)] - 1;  % Basis Assets
%e2 = [y.*repmat(sdf1,1,Ny)  y.*repmat(sdf2,1,Ny)] - 1;   % Test Assets
%e3 = [sdf1-infoz.mu(1) sdf2-infoz.mu(2)];
e = [e1];
m = mean(e)';

%corrcoef(e)