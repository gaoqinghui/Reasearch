function [ gamma ] = cal_gamma_tau( tau, p, q, x )
% Summary of this function goes here
%   Calcualte gamma_tau

Y = [p, q, x];
% var_num is the number of variables
var_num = size(p,2)+size(q,2)+size(x,2);
Spec = vgxset('n', var_num, 'nAR', 1, 'Constant', false);
[EstSpec] = vgxvarx(Spec,Y);

A = EstSpec.AR{:}; % A
V = EstSpec.Q; % Innovation matrix


i_1 = zeros(var_num,1);
i_2 = zeros(var_num,1);

i_1(1) = 1;
i_2(2) = 1;







temp_sum = zeros(size(A));

for i = 1:tau
    temp_sandwich = zeros(size(A));
    for j = 1:i
        temp_sandwich = temp_sandwich + A^(i-j)*V*(A^(i-j))';
    end
    temp_sum = temp_sum + A^(tau - i)*temp_sandwich;
end

gamma = i_1'*temp_sum*i_2;


end

