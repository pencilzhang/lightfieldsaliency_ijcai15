 function  Focsreg = Getfocregion( fcsdetectImg,pixelList )
% measure the focusness of a region

[h, w, chn] = size(fcsdetectImg);
tmpImg=reshape(fcsdetectImg, h*w, chn);
spNum = length(pixelList);
Focsreg = zeros(spNum, spNum);

for i = 1:spNum
    Ar = length(pixelList{i});  %2014lfsd(3)
    Fxysum = sum(tmpImg(pixelList{i},:));
    Fr(i) = Fxysum./Ar ; 
end
Focsreg = Fr';



