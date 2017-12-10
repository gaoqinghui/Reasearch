function S = logitS(b,infoz,y,x,z)
%function S = logitS(b,infoz,y,x,z)
%
% Spectral density matrix for Logit Model.  See gmmldv_d for a demo.

S = -logitj(b,infoz,[],y,x,z)*rows(y);
