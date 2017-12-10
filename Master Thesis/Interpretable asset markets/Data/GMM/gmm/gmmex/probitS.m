function S = probitS(b,infoz,y,x,z)
%function S = probitS(b,infoz,y,x,z)
%
% Spectral density matrix for Probit Model.  See gmmldv_d for a demo.
  
S = -probitj(b,infoz,[],y,x,z)*rows(y);