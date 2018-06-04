function Img = GetFrgimg(feaVec, pixelList, frameRecord,doNormalize,  fill_value)
% Fill back super-pixel values to image pixels a
if (~iscell(pixelList))
    error('pixelList should be a cell');
end

if (nargin < 4)
   doNormalize = 0;
end

if (nargin < 5)
    fill_value = 0;
end

h = frameRecord(1);
w = frameRecord(2);

top = frameRecord(3);
bot = frameRecord(4);
left = frameRecord(5);
right = frameRecord(6);

partialH = bot - top + 1;
partialW = right - left + 1;

partialImg = zeros(partialH, partialW);

for i=1:length(pixelList)
    partialImg(pixelList{i}) = feaVec(i);
end

if partialH ~= h || partialW ~= w
    feaImg = ones(h, w) * fill_value;
    feaImg(top:bot, left:right) = partialImg;
    Img = feaImg; 
else
    Img = partialImg;
end