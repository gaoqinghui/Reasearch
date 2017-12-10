function J=nlsqj(b,infoz,stat,y,x)

J = [-x -x.^2 -x.^3 -cos(b(5)*x) b(4)*x.*sin(b(5)*x)];
