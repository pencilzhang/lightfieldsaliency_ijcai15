clear all; clc;
addpath('util');


%% Parameter Settings
doFrameRemoving = true;
useSP = true;           %You  can set useSP = false to use regular grid for speed consideration
pixNumInSP =300;                            %pixels in each superpixe
alpha = 0.3;            % weight for combination of depth and color
saveBLS = false;        % save background slices


%% all-focus image;depth map;focal stack; focusness map
SRC_afi = '../data/SRCalfcim';          %Path of all-focus image
srcSuffix = '.jpg';                  %suffix for your input image
SRC_depth = '../data/SRCdep';           %Path of depth map
srcSuffix_depth = '.bmp';
SRC_fcness = '../data/SRCfcness';       %Path of focness stacks
SRC_bg = 'Result/BG';                    %Path for saving background image

RES_Sali = '../results/Salient_map';     %Path for saving final saliency maps
if ~exist(RES_Sali,'file');
    mkdir(RES_Sali);
end

files = dir(fullfile(SRC_afi, strcat('*', srcSuffix)));
files_depth=dir(fullfile(SRC_depth, strcat('*', srcSuffix_depth)));



%% Saliency Map Computation

for k=1:length(files)
    disp(k);
    srcName = files(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix));       
    
    srcImg = imread(fullfile(SRC_afi, srcName));        % all focs image
    
    if doFrameRemoving
        [noFrameImg, frameRecord] = removeframe(srcImg, 'sobel');
        [h, w, chn] = size(noFrameImg);
    else
        noFrameImg = srcImg;
        [h, w, chn] = size(noFrameImg);
        frameRecord = [h, w, 1, h, 1, w];
    end
    
    srcName_depth = files_depth(k).name;
    srcImg_depth = imread(fullfile(SRC_depth, srcName_depth));
    srcImg_depth = imresize(srcImg_depth,[360,360]);
    
    spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image
    [optsalMap,pixelList] = generate_prior_map(SRC_fcness,SRC_bg,noFrameImg,srcImg_depth,noSuffixName,alpha,spnumber,useSP,saveBLS);
    

    smapName = fullfile(RES_Sali, strcat(noSuffixName, '.png'));
    [partialImg,partialH,partialW] = ComputeSaliencyMap(optsalMap, pixelList, frameRecord,true);
    
    partialImg = (partialImg-min(partialImg(:)))/(max(partialImg(:))-min(partialImg(:)));
    partialImg = partialImg * 255;
    partialImg = uint8(partialImg);
    
    h = frameRecord(1);
    w = frameRecord(2);
    if partialH ~= h || partialW ~= w
        fill_value = 0;
        top = frameRecord(3);
        bot = frameRecord(4);
        left = frameRecord(5);
        right = frameRecord(6);
        feaImg = ones(h, w) * fill_value;
        feaImg(top:bot, left:right) = partialImg;
        imwrite(feaImg, smapName);
    else
        imwrite(partialImg,smapName);
    end
    
    
end




