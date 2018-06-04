clear all; clc;
addpath('util');


%% Parameter Settings
doFrameRemoving = true;
useSP = true;           %You  can set useSP = false to use regular grid for speed consideration
pixNumInSP =300;                            %pixels in each superpixe
alpha = 0.3;            % weight for combination of depth and color
saveBLS = false;        % save background slices


%% all-focus image;depth map;focal stack; focusness map
SRC_afi = '../Data/SRCalfcim';          %Path of all-focus image
srcSuffix = '.jpg';                  %suffix for your input image
SRC_depth = '../Data/SRCdep';           %Path of depth map
srcSuffix_depth = '.bmp';
SRC_fcness = '../Data/SRCfcness';       %Path of focness stacks
SRC_bg = 'Result/BG';                    %Path for saving background image

RES_Sali = 'salmap';     %Path for saving final saliency maps
if ~exist(RES_Sali,'file')
    mkdir(RES_Sali);
end

files = dir(fullfile(SRC_afi, strcat('*', srcSuffix)));
files_depth=dir(fullfile(SRC_depth, strcat('*', srcSuffix_depth)));



%% Saliency Map Computation

for k=1:length(files)
    disp(k);
    srcName = files(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix));       
    smapName = fullfile(RES_Sali, strcat(noSuffixName, '.png'));

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
    [idxImg, adjcMatrix, pixelList] = SLIC_Split(noFrameImg, spnumber);
    
    %% Get super-pixel properties
    meanRgbCol = GetMeanSuperPixel(noFrameImg, pixelList);%all-focus images
    meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255);
    meanPos = GetNormedMeanPos(pixelList, h, w);%centers of superpixel
    bdIds = GetBndPatchIds(idxImg);
    posDistM = GetDistanceMatrix(meanPos);
    
    %% select Background slice from focal stack
    fcsName = strcat(noSuffixName, '__refocus_');
    fcness_src = fullfile(SRC_fcness,fcsName);
    BGim = find_bgslice(fcness_src);
    if saveBLS
        bgName = fullfile(BG, strcat(noSuffixName,'.png'));
        imwrite(BGim, bgName);  %save BG image
    end
    
    [hb, wb, chnb] = size(BGim);
    spNumb = length(pixelList);
    location_prior = zeros(spNumb, chnb);
    meanBgIm = GetMeanSuperPixel(BGim, pixelList);
    BgDistM = GetDistanceMatrix(meanBgIm);
    imcentropos = measucentroid(noFrameImg,  h, w);
    for i=1:spNumb
        location_prior(i) = norm(imcentropos-meanPos(i,:));
    end
    bdConSigma = 1;
    bgfocus = 1-(exp((-meanBgIm.^2/(2 * bdConSigma * bdConSigma)) .* location_prior));
    
    %% depth and color contrast maps
    srcName_depth = files_depth(k).name;
    srcImg_depth = imread(fullfile(SRC_depth, srcName_depth));
    srcImg_depth = imresize(srcImg_depth,[360,360]);
    meanDepth = GetMeanSuperPixel(srcImg_depth, pixelList);
    
    colDistM = GetDistanceMatrix(meanLabCol);
    depthDistM = GetDistanceMatrix(meanDepth);
    featDistM =  alpha * depthDistM + (1-alpha)  *colDistM;

    sal = CalWeightedContrast(featDistM, posDistM, bgfocus);

    
    %% Saliency Optimization
    [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, featDistM);
    [bgProb, bdCon, bgWeight] = EstimateBgProb(featDistM, adjcMatrix, bdIds, clipVal, geoSigma);
    optsal = SaliencyOptimization(adjcMatrix, bdIds, featDistM, neiSigma, bgWeight, sal);
    
    [partialImg,partialH,partialW] = ComputeSaliencyMap(optsal, pixelList, frameRecord,true);
    
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


