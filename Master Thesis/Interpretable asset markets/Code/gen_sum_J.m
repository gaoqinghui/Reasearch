function [ sum_J ] = gen_sum_J( ts, J )
% Summary of this function goes here
%   future growth rates and returns
sum_J = zeros(size(ts(1:end-J)));

for i = 1:J
    sum_J = sum_J + ts(1+i:end-J+i);
end

