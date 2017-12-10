function f = roseng(x,infoz,stat,junk)
% Gradient of Rosenbrock's function
%
% Used in ROSEN_D, a demo for MINZ
%  infoz, stat, and junk are needed by functions called by MINZ

f = [-400*x(1)*(x(2)-x(1)^2) - 2*(1-x(1));
      200*(x(2)-x(1)^2)];
