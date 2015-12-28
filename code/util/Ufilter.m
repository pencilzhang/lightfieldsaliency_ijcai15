function u = Ufilter(D,eta)


w = 1:length(D);
a=1+(w/eta).^2;
b=1+((length(D)-w)/eta).^2;
u = 1./sqrt(a) + 1./sqrt(b);



