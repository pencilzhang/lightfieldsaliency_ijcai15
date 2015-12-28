function [partialImg,partialH,partialW] = ComputeSaliencyMap(feaVec, pixelList, frameRecord,doNormalize)

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

if (~iscell(pixelList))
    error('pixelList should be a cell');
end

% if (~ischar(imgName))
%     error('imgName should be a string');
% end

if (nargin < 4)
    doNormalize = true;
end

% if (nargin < 6)
%     fill_value = 0;
% end

% h = frameRecord(1);
% w = frameRecord(2);

top = frameRecord(3);
bot = frameRecord(4);
left = frameRecord(5);
right = frameRecord(6);

partialH = bot - top + 1;
partialW = right - left + 1;

partialImg = CreateImageFromSPs(feaVec, pixelList, partialH, partialW, doNormalize);
