function wCtr = CalWeightedContrast(posDistM, bgProb)
%% Calculate background probability weighted contrast

spaSigma = 0.67;     %sigma for spatial weight
posWeight = Dist2WeightMatrix(posDistM, spaSigma);  %posWeight = Wspa(p,pi)% exp(-d^2/(2*sigma^2));posDistM????????????????

wCtr = (posWeight * bgProb);   %(8) dapp(p,pi)*Wspa(p,pi)*Wibg?? dapp(p,pi)=colDistM ??????????????
wCtr = (wCtr - min(wCtr)) / (max(wCtr) - min(wCtr) + eps);

%post-processing for cleaner fg cue
removeLowVals = true;
if removeLowVals
    thresh = graythresh(wCtr);  %automatic threshold
    wCtr(wCtr < thresh) = 0;
end