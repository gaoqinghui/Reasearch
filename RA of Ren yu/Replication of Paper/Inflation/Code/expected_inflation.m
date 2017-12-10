function [ expected_p ] = expected_inflation( p, tau, T )
%Summary of this function goes here
%   Detailed explanation goes here
expected_p = zeros(105, 1);

for i = 1:length(expected_p)
    for j = 1:(12*T)
        expected_p(i) = expected_p(i) + log(p(240+i-j)/p(240+i-j-tau));
    end
    expected_p(i) = expected_p(i)/(T*tau);
end
end

