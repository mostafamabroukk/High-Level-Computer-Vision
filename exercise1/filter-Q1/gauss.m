function [G,x] = gauss(sigma)
% ... 
range=(3*sigma)+1;
x=(-range:range);
G=1/(sqrt(2*pi)*sigma)*exp(-(x.^2)/(2*sigma^2));

end