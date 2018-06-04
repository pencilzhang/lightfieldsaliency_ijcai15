function Du = GetMeanSuperPixel(fcness_src, Bginfo, pixelList)
% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014


% srcSuffix = '.jpg';
srcSuffix_fcnes = '.png';
% fcsli_file = dir(fullfile(fstk_src,strcat('*', srcSuffix)));           % focal stack
fcness_file = dir(fullfile(fcness_src,strcat('*', srcSuffix_fcnes)));
N = length(fcness_file) ;
eta = 28;
lambda = 0.2 ;
% sigma = 45;
BLSI = zeros(N,1);

% for k=1:N
    %% read   slice  and focnessmap
    srcName = Bginfo.name;
    noSuffixName = srcName(1:end-length(srcSuffix_fcnes));
    fcnesImg = double(imread(fullfile(fcness_src, strcat(noSuffixName ,srcSuffix_fcnes))));  % read focusness map
   
    
    [h, w, chn] = size(fcnesImg);
    tmpImg=reshape(fcnesImg, h*w, chn);
    
    spNum = length(pixelList);
    Du=zeros(spNum, chn);
    
    for i=1:spNum
        %     meanCol(i, :) = mean(tmpImg(pixelList{i},:), 1);
        img = tmpImg(pixelList{i},:);
        
%         alph = sum(img(:));
%         D =  (1/alph)*img;
        D = img/numel(pixelList{i});
        %         Dy = (1/alph)*sum(fcnesImg,2);
        %         Dy = Dy';
        
        %% U-shaped" 1D band suppression filter (5)
        U = Ushapfilter_fix(D,eta);
        %         Uyh = Ushapfilter_fix(Dy,eta);
        
        %% Background Likelihood Score(BLS) (6)
        %         rho = exp(-(lambda*k)/N);
        %         BLSI(k) = rho*(Dx*Uxw'+Dy*Uyh');
        
        Du(i) = D' * U';
        
        
    end
    
% end
% if chn ==1 %for gray images
%     meanCol = repmat(meanCol, [1, 3]);
% end