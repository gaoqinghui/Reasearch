function G=cir_dj(b,infoz,stat,y,X,Z)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%                        %%%%%
%%%%%   Matrice jacobienne   %%%%%
%%%%%                        %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = rows(X);
dmb1 = 2.*b(1) - 2.*y + 2.*b(2).*X;
dmb2 = 2.*b(2).*X.^2 - 2.*y.*X + 2.*b(1).*X;

dmc1 = [-ones(T,1) dmb1];
dmc2 = [-X dmb2];
dmc3 = [0.*ones(T,1) -X];

col1 = reshape(Z'*dmc1/T,4,1);
col2 = reshape(Z'*dmc2/T,4,1);
col3 = reshape(Z'*dmc3/T,4,1);

G = [col1 col2 col3];

