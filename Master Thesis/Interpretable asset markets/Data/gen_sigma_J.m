function [ sigma_J ] = gen_sigma_J( eps, J )
% Summary of this function goes here
%   generate sigma J from epsilon

% eps = abs(eps);

sigma_J = zeros(size(eps,1)-J,1);

for i = 1:J
    sigma_J = sigma_J + eps(i:end+i-J-1);
end

sigma_J = log(sigma_J);
    
end

