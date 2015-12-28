function centropos = measucentroid(Img, height, width)

if size(Img,3) == 3
    im = rgb2gray(Img);
else
    im = Img;
end
[row,col] = size(im);
x = ones(row,1)*[1:col];
y = [1:row]'*ones(1,col);
area = sum(sum(im));
imcentx = (sum(sum(double(im).*x))/area)/ height;
imcenty = (sum(sum(double(im).*y))/area)/ width;
centropos = [imcentx imcenty];
