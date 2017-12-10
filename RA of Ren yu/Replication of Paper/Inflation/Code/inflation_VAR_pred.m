function [ i_pred ] = inflation_VAR_pred( i, r )
% Summary of this function goes here
%   Detailed explanation goes here

i_pred = nan(size(i,1)-1,1);


Y = [i, r];
% var_num is the number of variables
var_num = size(i,2)+size(r,2);
Spec = vgxset('n', var_num, 'nAR', 1, 'Constant', false);
[EstSpec] = vgxvarx(Spec,Y);

A = EstSpec.AR{:}; % A
V = EstSpec.Q; % Innovation matrix


i_1 = zeros(var_num,1);
i_1(1) = 1;

for i = 1:length(i_pred)
    i_pred(i) = Y(i,:)*A*i_1;
end

end

