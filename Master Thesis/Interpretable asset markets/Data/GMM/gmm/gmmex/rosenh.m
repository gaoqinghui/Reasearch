function stat = rosenh(x,infoz,stat,junk)
% Hessian of Rosenbrock's function
%
% Used in ROSEN_D, a demo for MINZ
%  infoz, stat, and junk are needed by functions called by MINZ

H = [1200*x(1)^2 - 400*x(2) + 2    -400*x(1);
      -400*x(1)  200];

stat.Hi = H\eye(size(H));
stat.Hcond = cond(stat.Hi);
