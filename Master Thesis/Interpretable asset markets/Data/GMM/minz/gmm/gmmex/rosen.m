function f = rosen(x,infoz,stat,junk)
% Rosenbrock's function
%   f = 100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
%
% Used in ROSEN_D, a demo for MINZ
%  infoz, stat and junk are needed by functions called by MINZ

f = 100*(x(2)-x(1)^2)^2 + (1-x(1))^2;

