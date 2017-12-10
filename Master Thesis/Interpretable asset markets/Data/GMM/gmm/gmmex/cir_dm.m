function [m,e]=cir_dm(b,infoz,stat,y,X,Z)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%                         %%%%%
%%%%%   Matrice des moments   %%%%%
%%%%%                         %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = rows(X);
e1 = y - b(1) - b(2).*X;
e2 = e1.^2 - b(3).*X;
e = [e1 e2];

m = reshape(Z'*e/T,4,1);


