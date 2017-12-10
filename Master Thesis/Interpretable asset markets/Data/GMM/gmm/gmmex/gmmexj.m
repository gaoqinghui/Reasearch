function G=gmmexj(b,infoz,stat,Y,X,Z)

[T, neq] = size(Y);
R = X(:,2:cols(X));
cg = X(:,1);

imrs = b(1)*cg.^(-b(2));
dimrs1 = cg.^(-b(2));
dimrs2 = -imrs.*log(cg);
G = [];
for i = 1:cols(R)
  temp = [Z'*(dimrs1.*R(:,i)) Z'*(dimrs2.*R(:,i))]/T;
  G = [G; temp];
end

