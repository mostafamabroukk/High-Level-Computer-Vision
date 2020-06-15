function outimage=gaussianfilter(img,sigma)

[g,x]=gauss(sigma);
outimage=conv2(g,g,img,'same');

end