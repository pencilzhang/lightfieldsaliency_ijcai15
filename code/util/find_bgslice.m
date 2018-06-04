function BGim = generate_focus_bg(fcness_src)

srcSuffix_fcnes = '.png';
fcness_file = dir(fullfile(fcness_src,strcat('*', srcSuffix_fcnes)));
N = length(fcness_file) ;
eta = 28;
lambda = 0.2 ;
BLSI = zeros(N,1);

for k=1:N
    %% read   slice  and focnessmap
    srcName = fcness_file(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix_fcnes));
    fcnesImg = double(imread(fullfile(fcness_src, strcat(noSuffixName ,srcSuffix_fcnes))));  % read focusness map
    
    %% 1D focusness distributions  (4)
    alph = sum(fcnesImg(:));
    Dx =  (1/alph)*sum(fcnesImg);
    Dy = (1/alph)*sum(fcnesImg,2);
    Dy = Dy';
    
    %% U-shaped" 1D band suppression filter (5)
    Uxw = Ushapfilter_fix(Dx,eta);
    Uyh = Ushapfilter_fix(Dy,eta);
    
    %% Background Likelihood Score(BLS) (6)
    rho = exp(-(lambda*k)/N);
    BLSI(k) = rho*(Dx*Uxw'+Dy*Uyh');

    List(k).name = strcat(noSuffixName ,srcSuffix_fcnes);
    List(k).Bls = BLSI(k);
    List(k).FnesIm = fcnesImg;
    
end

% Choose the slice with the highest BLSI as background slice Ib
BGslc_num = BLSI==max(BLSI);
Bginfo = List(BGslc_num);
BGimage = Bginfo.FnesIm;
ma = max(max(BGimage));
mi = min(min(BGimage));
BGim = (BGimage-mi)./(ma-mi);

