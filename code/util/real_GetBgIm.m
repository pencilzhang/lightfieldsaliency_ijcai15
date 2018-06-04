
function BGim = real_GetBgIm(fcness_src)
% EstimateBgProb
%% 1. Parameter Settings

% srcSuffix = '.jpg';
srcSuffix_fcnes = '.png';
% fcsli_file = dir(fullfile(fstk_src,strcat('*', srcSuffix)));           % focal stack
fcness_file = dir(fullfile(fcness_src,strcat('*', srcSuffix_fcnes)));
N = length(fcness_file) ;
eta = 28;
lambda = 0.2 ;
% sigma = 45;

for k=1:N
    %% read   slice  and focnessmap
    srcName = fcness_file(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix_fcnes));
%     srcImg = imread(fullfile(fstk_src, srcName));      % read each slice from a focal stack. eg. Data\SRCfcstk\1__refocus_\1__refocus_00.jpg
%     srcImg = imresize(srcImg,[360,360]);
%     [~, ~, chn] = size(srcImg);
    fcnesImg = double(imread(fullfile(fcness_src, strcat(noSuffixName ,srcSuffix_fcnes))));  % read focusness map
    % Discriminative Blur Detection Features CVPR14
    % %      maaa = max(max(fcnesImg));
    % %      miii = min(min(fcnesImg));
    % %      fcnesImg = (fcnesImg-miii)./(maaa-miii);%?? Data\focsdetmap\9__refocus_\9__refocus_00.png
    %         fcsdetImg =  imcomplement(fcnesImg);
    %         figure; imshow(fcsdetImg);
    
%     %% Segment input rgb image into patches (SP/Grid)
%     spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image
%     
%     if useSP
%         [idxImg, adjcMatrix, pixelList] = SLIC_Split(srcImg, spnumber);
%     else
%         [idxImg, adjcMatrix, pixelList] = Grid_Split(srcImg, spnumber);
%     end
    
%     %% compute focusness region (3)
%     Freg = Getfocregion( fcnesImg,pixelList );      % measure the focusness of a region
    
    %% 1D focusness distributions  (4)
    alph = sum(fcnesImg(:));
    Dx =  (1/alph)*sum(fcnesImg)*10;
    Dy = (1/alph)*sum(fcnesImg,2)*10;
    Dy = Dy';
    
    %% U-shaped" 1D band suppression filter (5)
    Uxw = Ushapfilter(Dx,eta);
    Uyh = Ushapfilter(Dy,eta);
    
    %% Background Likelihood Score(BLS) (6)
    rho = exp(-(lambda*k)/N);
    BLSI(k) = rho*(Dx*Uxw+Dy*Uyh);
%     Finfobls(k)=  BLSI;
    
%     %% 1D gaussian filter(7)
%     Gxw = Gausfilter(Dx,sigma);
%     Gyh = Gausfilter(Dy,sigma);
    
%     %%  objectness score (OS)  for each focal slice(8)
%     OSI =( Dx*Gxw+Dy*Gyh);
%     FinfoOSI(k)=  OSI;
    
%     %%  foreground likelihood score (FLS)(9)
%     FLSI = OSI*(1-BLSI);
%     FinfoFLSI(k)=  FLSI;
    
    List(k).name = strcat(noSuffixName ,srcSuffix_fcnes);
%     List(k).idxI = idxImg;
%     List(k).am = adjcMatrix;
%     List(k).pxl = pixelList;
    List(k).Bls = BLSI(k);
%     List(k).Osi = OSI; %objectness score
%     List(k).Flsi = FLSI; % foreground likelihood score 
%     List(k).Freg = Freg; %measure the focusness of a region
    List(k).FnesIm = fcnesImg;
end

% FGcandi = find( FinfoFLSI>=mean(FinfoFLSI)); % foreground slice candidates
% blsinfo = Finfobls;
%    blsinfo(FGcandi)=0;
BGslc_num = BLSI==max(BLSI);
Bginfo = List(BGslc_num);
BGimage = Bginfo.FnesIm;
ma = max(max(BGimage));
mi = min(min(BGimage));
BGim = (BGimage-mi)./(ma-mi);

