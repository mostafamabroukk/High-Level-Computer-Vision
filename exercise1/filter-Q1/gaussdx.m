function [D, x] = gaussdx(sigma)

range=(3*sigma)+1;
x=(-range:range);
D=(-1/(sqrt(2*pi)*sigma^3)).*x.*exp(-(x.^2)/(2*sigma^2));

end