function maxCol = GetMaxSuperPixel(image, pixelList)
% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

[h, w, chn] = size(image);
tmpImg=reshape(image, h*w, chn);

spNum = length(pixelList);
maxCol=zeros(spNum, chn);
for i=1:spNum
    maxCol(i, :) = max(tmpImg(pixelList{i},:),[], 1);      %tmpImg(pixelList{i},:) ���������ΪpixelList{i}ʱ����ɫ
end
% if chn ==1 %for gray images
%     meanCol = repmat(meanCol, [1, 3]);
% end