%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% draw neural activity for each small factor until the time small factor
% exploded or disappeared
% 
% computation from PreLMatTracker_v_0_1
%
% -------------------------------------------------------------------------
% 
% Ziqiang Wei
% weiz@janelia.hhmi.org
%
%

function NeuralActivityFactorTime_v0_4(nFile)
    addpath('../Func');
    setDir;    
    fileName      = fileNames{nFile};   %#ok<*USENS>
    load([tempDatDir, fileName, '.mat'], 'dff', 'timePoints')
    load([tempDatNetDir, 'LONOLoading_' fileName, '_v_0_2.mat'], 'preLMat', 'preLMatIndex', 'preLMatTime') 
    numTime       = length(timePoints);
    numNeuron     = size(preLMat, 1);
    numFactor     = max(preLMatIndex);
    preLMatNeuron = sum(preLMat);
    timeWin       = 40;
    mColor        = cbrewer('qual', 'Dark2',  numFactor, 'cubic');
    nStep         = 10;
    existLMat     = false(numNeuron, 1);

    figure;
    totNeuron     = 0;
    for nFactor   = 1:numFactor
        timeInd   = preLMatTime(:, preLMatNeuron<4 & preLMatIndex == nFactor);
        zeroTime  = min(timeInd);
        endTime   = min(max(timeInd), zeroTime+timeWin);
        LMat      = preLMat(:, preLMatNeuron<4 & preLMatIndex == nFactor & preLMatTime<=endTime);
        LMatInd   = sum(LMat, 2)>0;
        LMatInd(existLMat & LMatInd) = false;
        existLMat = existLMat | LMatInd;
        zeroTime  = min(timeInd);
        endTime   = min(max(timeInd), zeroTime+timeWin);
        minTime   = max(zeroTime - timeWin, 1);
        timeRange = timePoints(minTime)+1:timePoints(endTime);
        timeMarks = timeRange - timePoints(zeroTime);
        if sum(LMatInd) >0 
            dffValue  = bsxfun(@plus, zscore(dff(LMatInd, timeRange), [], 2), (1:sum(LMatInd))'*nStep + totNeuron*nStep);
            dffMedian = median(dffValue, 2);
            totNeuron = totNeuron + sum(LMatInd);
            hold on
            plot(timeMarks, dffValue, 'Color', mColor(nFactor,:), 'linewidth', 0.5);
            xlim([-timePoints(timeWin) timePoints(timeWin)+10])
            gridxy([], dffMedian+1.5, 'color', 'k', 'linestyle', '--')
            axis off
        end
    end    
    ylim([-1 (totNeuron+1)*nStep+1])
    gridxy(0, [], 'color', 'k', 'linestyle', '--')
    setPrint(20, 4*numFactor, [plotNetDir 'SingleNeuronDynamicsLocalCommunity_' fileName], 'pdf')
end