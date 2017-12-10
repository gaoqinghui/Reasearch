% Demonstration of MINZ Optimization Library
%  Rosenbrock's (Banana) Function
%  f = 100*(x(2)-x(1)^2)^2 + (1-x(1))^2

clear all

%more on
clf
disp(' MINZ Demo:   Minimize f = 100*(x(2)-x(1)^2)^2 + (1-x(1))^2')
disp(' Function has a minimum at (1,1)')
disp(' ')

x0=[0;0];
a = [-1.1:.01:1.1]';
b = a;
[A,B]=meshgrid(a',b');
Z = 100.*(B-A.*A).^2 + (1-A).^2;
mesh(a,b,Z)
view(130,30)
xlabel('x(1)')
ylabel('x(2)')
disp('Strike a key to continue')
pause
contour(a,b,Z,[0:.2:1 1.5 2])
axis([-.1 1.1 -.1 1.1])
xlabel('x(1)')
ylabel('x(2)')
hold on
plot(0,0,'rx',1,1,'r*')

disp(' We will use x0=[0;0] as a starting point')
disp(' ')
disp(' First Use default options.  Specify function in infoz structure')
infoz.func='rosen'
disp('[x,outfo,stat] = minz(x0,infoz.func,infoz,x0);')
[x,outfo,stat] = minz(x0,infoz.func,infoz,x0);
title('Banana Function: DFP Direction (Default)')
text(0,1,[int2str(stat.iter) ' Steps, x = ' num2str(x','%7.4f')])
plot(stat.hist(:,1),stat.hist(:,2),'.')
disp('Strike a key to continue')
pause

disp(' ')
disp('Now try BFGS Direction')
infoz.hess='bfgs'
clf
contour(a,b,Z,[0:.2:1 1.5 2])
axis([-.1 1.1 -.1 1.1])
hold on
plot(0,0,'rx',1,1,'r*')
[x,outfo,stat] = minz(x0,infoz.func,infoz,x0);
title('Banana Function: BFGS Direction')
text(0,1,[int2str(stat.iter) ' Steps, x = ' num2str(x','%7.4f')])
plot(stat.hist(:,1),stat.hist(:,2),'.')
disp('Strike a key to continue')
pause

disp(' ')
disp('The first two used Numerical Derivatives.')
disp('  Lets try analytic Gradient in the file roseng.m')
infoz.grad='roseng'
clf
contour(a,b,Z,[0:.2:1 1.5 2])
axis([-.1 1.1 -.1 1.1])
hold on
plot(0,0,'rx',1,1,'r*')
[x,outfo,stat] = minz(x0,infoz.func,infoz,x0);
title('Banana Function: BFGS Direction, Analytic Gradient')
text(0,1,[int2str(stat.iter) ' Steps, x = ' num2str(x','%7.4f')])
plot(stat.hist(:,1),stat.hist(:,2),'.')
disp('Strike a key to continue')
pause

disp(' ')
disp('We can also use Analytic Hessian from the file rosenh.m')
infoz.hess='rosenh'
clf
contour(a,b,Z,[0:.2:1 1.5 2])
axis([-.1 1.1 -.1 1.1])
hold on
plot(0,0,'rx',1,1,'r*')
[x,outfo,stat] = minz(x0,infoz.func,infoz,x0);
title('Banana Function: Analytic Gradient and Hessian')
text(0,1,[int2str(stat.iter) ' Steps, x = ' num2str(x','%7.4f')])
plot(stat.hist(:,1),stat.hist(:,2),'.')

disp(' ')
disp('Finally, lets try the Steepest Descent method.')
infoz.hess='sd'
clf
contour(a,b,Z,[0:.2:1 1.5 2])
axis([-.1 1.1 -.1 1.1])
hold on
plot(0,0,'rx',1,1,'r*')
[x,outfo,stat] = minz(x0,infoz.func,infoz,x0);
title('Banana Function: Steepest Descent')
text(0,1,[int2str(stat.iter) ' Steps, x = ' num2str(x','%7.4f')])
plot(stat.hist(:,1),stat.hist(:,2),'.')
disp('Strike a key to continue')
pause

disp(' ')
disp('Notice the step size seems too large.')
disp('Try stepz instead of step2.')
clf
contour(a,b,Z,[0:.2:1 1.5 2])
axis([-.1 1.1 -.1 1.1])
hold on
plot(0,0,'rx',1,1,'r*')
infoz.step='stepz';
[x,outfo,stat] = minz(x0,infoz.func,infoz,x0);
title('Banana Function: Steepest Descent, STEPZ')
text(0,1,[int2str(stat.iter) ' Steps, x = ' num2str(x','%7.4f')])
plot(stat.hist(:,1),stat.hist(:,2),'.')


clear A B Z a b infoz stat outfo x x0
