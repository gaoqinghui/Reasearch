function e=nlsqe(b,infoz,stat,y,x)

e = y - b(1)*x - b(2)*x.^2 - b(3)*x.^3 - b(4)*cos(b(5)*x);

