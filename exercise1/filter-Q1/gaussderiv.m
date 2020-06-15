function [imgDx,imgDy]=gaussderiv(img,sigma)

% ...
[g,x]=gauss(sigma);
[d,x]=gaussdx(sigma);

imgDx=conv2(g,d,img,'same');
imgDy=conv2(d,g,img,'same');

end