function wCtr = CalWeightedContrast(feaDistM, posDistM, bgProb)
%% Calculate background probability weighted contrast

spaSigma = 0.67;     %sigma for spatial weight
posWeight = Dist2WeightMatrix(posDistM, spaSigma);  %posWeight = Wspa(p,pi)% exp(-d^2/(2*sigma^2));posDistM³¬ÏñËØ¼ä¿Õ¼ä¾àÀë

wCtr = (feaDistM .* posWeight * bgProb);   %(8) dapp(p,pi)*Wspa(p,pi)*Wibg£» dapp(p,pi)=colDistM ³¬ÏñËØ¼äÑÕÉ«²î
wCtr = (wCtr - min(wCtr)) / (max(wCtr) - min(wCtr) + eps);

%post-processing for cleaner fg cue
removeLowVals = true;
if removeLowVals
    thresh = graythresh(wCtr);  %automatic threshold
    wCtr(wCtr < thresh) = 0;
end