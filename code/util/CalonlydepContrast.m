function wCtr = CalonlydepContrast(colDistM, posDistM)

spaSigma = 0.4;     %sigma for spatial weight
posWeight = Dist2WeightMatrix(posDistM, spaSigma);  %posWeight = Wspa(p,pi)% exp(-d^2/(2*sigma^2));posDistM³¬ÏñËØ¼ä¿Õ¼ä¾àÀë

%bgProb weighted contrast
wCtr = sum(colDistM .* posWeight,2);   %(8) dapp(p,pi)*Wspa(p,pi)£» dapp(p,pi)=colDistM ³¬ÏñËØ¼äÑÕÉ«²î

wCtr = (wCtr - min(wCtr)) / (max(wCtr) - min(wCtr) + eps);

%post-processing for cleaner fg cue
removeLowVals = true;
if removeLowVals
    thresh = graythresh(wCtr);  %automatic threshold
    wCtr(wCtr < thresh) = 0;
end

