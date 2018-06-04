function distM = GetcoldepDistanceMatrix(colorfeat,depthfeat,pixelList)
% Get pair-wise distance matrix between each rows in color and depth feature
%% depth contrast
[h, w, chn] = size(depthfeat);
tmpImg=reshape(depthfeat, h*w, chn);
spNum = length(pixelList);
DepthDistM = zeros(spNum, spNum);
meandepth=zeros(spNum, chn);

for i = 1 : spNum
 meandepth(i, :) = mean(tmpImg(pixelList{i},:),1);  %The average depth of each superpixel 
 
end

for n = 1:size(meandepth, 2)
   DepthDistM = (repmat(meandepth(:,n), [1, spNum]) - repmat(meandepth(:,n)', [spNum, 1])).^2; %the Euclidean distance between superpixels' average depth
end
DepthDistM = sqrt(DepthDistM); %Dd(rk-ri)=|dk-di| 
% distM =  0.7*depthdistM ;

%% corlor contrast (wCtr)
spNum1 = size(colorfeat, 1);
ColorDistM = zeros(spNum1, spNum1);

for n = 1:size(colorfeat, 2)
    ColorDistM = ColorDistM + ( repmat(colorfeat(:,n), [1, spNum1]) - repmat(colorfeat(:,n)', [spNum1, 1]) ).^2; %the Euclidean distance between superpixels' average colors
end
ColorDistM = sqrt(ColorDistM);  %dapp(rk-ri)=|ck-ci|
% ColorDistM = 0.3*ColorDistM;

%% combin contrast
 distM =  0.3*DepthDistM +0.7*ColorDistM;
  %  distM =  0.7*DepthDistM +0.3*ColorDistM;

