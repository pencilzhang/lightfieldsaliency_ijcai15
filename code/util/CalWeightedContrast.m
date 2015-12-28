function wCtr = CalWeightedContrast(feaDistM, posDistM, bgProb)
%% Calculate background probability weighted contrast

spaSigma = 0.67;     
posWeight = Dist2WeightMatrix(posDistM, spaSigma); 

wCtr = (feaDistM .* posWeight * bgProb);  
wCtr = (wCtr - min(wCtr)) / (max(wCtr) - min(wCtr) + eps);

%post-processing for cleaner fg cue
removeLowVals = true;
if removeLowVals
    thresh = graythresh(wCtr);  %automatic threshold
    wCtr(wCtr < thresh) = 0;
end