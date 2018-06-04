function   G = Gausfilter(D,sigma)

w = length(D);
%% gauss  filter
id = mean(find(D==max(D)));
u = id;

for i =1:w
    a = i-u;
    b=2*(sigma)^2;
    Gassfliter(i)=exp(-a/b);
end

for j = 1:w 
   Gw(j) =  Gassfliter(j)*D(j);    
 end
 G = Gw';
