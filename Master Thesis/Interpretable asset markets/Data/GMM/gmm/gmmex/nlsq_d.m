% NLSQ_D  Demo for Nonlinear Least Squares with MINZ Package
%

% Written by: Mike Cliff,  Purdue Finance, mcliff@mgmt.purdue.edu
% Modified:   7/21/00

clear infoz

disp(' Demo for Nonlinear Least Squares with MINZ Package')
disp(' The model is y = b(1)*x + b(2)*x.^2 + b(3)*x.^3 + b(4)*cos(b(5)*x)')
disp(' or y = X*b(1:3) + b(4)*cos(b(5)*x)')
disp(' ')
disp(' The last term introduces the non-linearity.')
disp(' For a starting point we will ignore this term, and get OLS estimates')
disp(' for the first three parameters.')

nlsqdat
X = [x x.^2 x.^3];
b0 = (X'*X)\X'*y;
e0 = y - X*b0;

disp(' We can plot the linear model errors to learn about the nonlinearity.')
disp(' A reference cos(x) is added in red.')
disp(' ')
clf
plot(x,e0,x,cos(x),'r')

disp(' The plot reveals that the model needs to include a cos(x)')
disp(' term with amplitude of roughly -2 and frequency 2x.')
b0 = [b0;-2;2]

disp('Strike a key to see a plot of our initial guess (dotted) versus actual.')
disp(' ')
pause
yhat = X*b0(1:3)-2*cos(2*x);
plot(x,y,x,yhat,':')
hold on


disp(' Now we use the infoz structure to tell MINZ what to minimize.')
disp(' By inidicating this is an LS problem, MINZ knows to form f = ||e||')
disp(' We need to tell it what the error vector function is, and if desired,')
disp(' the derivative of the errors wrt the parameters (Jacobian).')
disp(' ')
disp(' We also choose the Hessian type:')
disp(' 1 = Steepest Descent')
disp(' 2 = Gauss Newton')
disp(' 3 = Levenberg-Marquardt')
disp(' 4 = DFP')
disp(' 5 = BFGS')
htype=input('Enter the number for your selection. ');
if htype == 1, infoz.hess='sd';
elseif htype == 2, infoz.hess='gn';
elseif htype == 3, infoz.hess='marq';
elseif htype == 4, infoz.hess='dfp';
else infoz.hess='bfgs'; end
infoz.func = 'lsfunc';
infoz.momt = 'nlsqe';
infoz.jake = 'nlsqj';
infoz.call='ls'
disp(' ')
disp(' Now we call MINZ: [b,outfo,stat] = minz(b0,infoz.func,infoz,y,x)')

disp('Hit a key to run the minimization')
pause
[b,outfo,stat]=minz(b0,infoz.func,infoz,y,x);

plot(x,X*b(1:3)+b(4)*cos(b(5)*x),'r')
disp(' The red line is the estimated nonlinear model.')
disp(' Initial Parameter Values')
disp(b0')
disp(' Estimated Parameter Values and Standard Errors')
e1 = y - (X*b(1:3)+b(4)*cos(b(5)*x));
se = sqrt(var(e1)*diag(stat.Hi));
mprint3(b',se');


b2 = [2.176818; 0.243023; -0.092229; -2.078671;  1.993280]; % SAS Results
b2se = [0.10148; 0.04955; 0.0057978; 0.05318; 0.0081620];
e2 = y - (X*b2(1:3)+b2(4)*cos(b2(5)*x));
disp(' ')
disp('SAS Results')
mprint3(b2',b2se');
disp(' ')
disp('Compare to Matlab''s LSQNONLIN Function')
myoptions = optimset('MaxFunEvals',10000);
[b3,e3sq,e3,flag,out,lambda,jake] = lsqnonlin('nlsqalt',b0,[],[],myoptions);
b3se = (jake'*jake)\eye(cols(jake));
b3se = sqrt(diag(var(e3)*b3se));
mprint3(b3',b3se');

disp(' ')
disp('Hit a Key to Plot Error Terms:')
pause
clf
plot(x,y-yhat,'g',x,e1,'r',x,e2,'b',x,e3,'m')
legend('b(0) Guess','MINZ','SAS','LSQNONLIN')

%clear X b b0 htype infoz outfo stat x y nlsq
