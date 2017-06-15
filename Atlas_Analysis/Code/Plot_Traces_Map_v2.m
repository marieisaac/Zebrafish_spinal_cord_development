function Plot_Traces_Map_v2(nFile)
% plot factors with convex hull, with moving points
addpath('../Func');
setDir;
load([DirNames{nFile} '\data.mat'], 'new_x', 'new_y', 'new_z', 'dff', 'side', 'timePoints', 'activeNeuronMat', 'tracks');
load([DirNames{nFile} '\LONOLoading.mat'], 'CorrectedLMat');
load([DirNames{nFile} '\ref_points_imaris.mat'], 'ra', 'rb')

ratio3D = 6;
ra = double(ra);
rb = double(rb);
points = squeeze(tracks(:, end, :));
points(:, 3) = points(:, 3)*ratio3D;

nNeurons = numel(new_x);

[~, neworder] = sort(new_x);

neworder = [neworder(side(neworder)==1); neworder(side(neworder)==2)];

mColor = cbrewer('qual', 'Dark2',  8, 'cubic');
mColor            = [mColor; cbrewer('qual', 'Set2',  128, 'cubic')];
preLMat           = nan(nNeurons, 1);

video          = VideoWriter([PlotDir '\movie_dynamic_loc' dataset{nFile}, '.avi'], 'Uncompressed AVI');
video.FrameRate = 10;
open(video);


% frame size in pixels
frameW = 1920;
frameH = 1088;
fig = figure('units', 'pixels', 'position', [0 0 , frameW, frameH]);
set(0, 'defaultaxeslayer', 'top')

linew = 1.25;

for period = 1:numel(timePoints)
    timeRange = timePoints(period)+1:timePoints(period)+1200;
    clf reset
    radius = 0.2;
    
    LMat          = CorrectedLMat{period};
    LMat(isnan(LMat)) = 0;
    LMat(:, sum(LMat, 1)==0) = [];
    activeTag = activeNeuronMat(:, period);
    
    % determine the factor index
    if size(LMat,2) >= 1
        if sum(~isnan(preLMat(:))) == 0
            factorIndex  = 1:size(LMat, 2);
            preLMat      = LMat;
        else
            
            [~, maxFactorPerNeuronIndex] = max(LMat(sum(LMat, 2)>0, :), [], 2);
            sideRemoveList  = histc(maxFactorPerNeuronIndex, 1:size(LMat, 2)) <2; % remove the factor has no dominate factors
            
            LMat(:, sideRemoveList) = [];
            LMat            = LMat > 0;
            sizeLMat        = sum(LMat, 1);
            [~, indexLMat]  = sort(sizeLMat, 'descend');
            LMat            = LMat(:, indexLMat);
            factorIndex     = zeros(size(LMat, 2), 1);
            
            % compute similarity matrix
            similarityScore = zeros(size(LMat, 2), size(preLMat, 2));
            for nFactor     = 1:size(LMat, 2)
                if sum(isnan(LMat(:)))>0; keyboard();end
                similarityScore(nFactor, :) = sum(bsxfun(@and, LMat(:, nFactor), preLMat));
            end
            
            % check if any prefactor has no connection with new factors
            % decide which factor is not included in preLMatIndex
            % maxIndex is the factor with the maximum coverage with the prefactors
            [~, maxIndex]   = max(similarityScore, [], 1);
            
            % check if any prefactor is merged (factor has maximum coverages with more than one prefactors, pick the larger one as its index)
            for nFactor     = 1:size(LMat, 2)
                nFacotrNumPreFactor = sum(maxIndex == nFactor);
                switch nFacotrNumPreFactor
                    case 0
                        preLMat = [preLMat, LMat(:, nFactor)];
                        factorIndex(nFactor) = size(preLMat, 2);
                    case 1
                        if similarityScore(nFactor, maxIndex == nFactor) == 0
                            preLMat = [preLMat, LMat(:, nFactor)];
                            factorIndex(nFactor) = size(preLMat, 2);
                        else
                            preLMatIndex         = find(maxIndex == nFactor);
                            factorIndex(nFactor) = preLMatIndex;
                            preLMat(:, preLMatIndex) = preLMat(:, preLMatIndex) | LMat(:, nFactor);
                        end
                    otherwise
                        preLMatIndex         = find(maxIndex == nFactor);
                        [~, nFactorMaxIndex] = max(similarityScore(nFactor, preLMatIndex));
                        factorIndex(nFactor) = preLMatIndex(nFactorMaxIndex);
                        preLMat(:, preLMatIndex(nFactorMaxIndex)) = preLMat(:, preLMatIndex(nFactorMaxIndex)) | LMat(:, nFactor);
                end
            end
        end
    end
    
    
    % plot calcium traces
    subplot(3, 2, [1 3 5]);
    hold on
    for i = 1:size(LMat, 1)
        if ~activeTag(i)
            plot(linspace(0, 5, numel(timeRange)), zscore(dff(i, timeRange))+find(neworder==i)*4, 'Color', [.8, .8, .8], 'linewidth', linew);
        end
    end
    for i = 1:size(LMat, 1)
        if activeTag(i)
            if ~any(isnan(LMat(i, :))) && sum(LMat(i, :))>0 && size(LMat,2) >= 1
                [~, nFactor] = max(LMat(i, :));
                plot(linspace(0, 5, numel(timeRange)), zscore(dff(i, timeRange))+find(neworder==i)*4, 'Color', mColor(factorIndex(nFactor), :), 'linewidth', linew);
            else
                plot(linspace(0, 5, numel(timeRange)), zscore(dff(i, timeRange))+find(neworder==i)*4, 'k', 'linewidth', linew);
            end
        end
    end
    xlim([0, 5])
    ylim([0, size(LMat, 1)*4+4]);
    set(gca, 'YTickLabel', '');
    %     text(zeros(numel(neworder), 1), (1:numel(neworder))*4, num2str(neworder));
    plot([0, 5], [sum(side==1) * 4, sum(side==1) * 4], 'k--');
    hold off
    
    % plot spatial organization
    % normalize xyz coordinates according to the reference
    current_points = squeeze(mean(tracks(:, timeRange, :), 2));
    current_points(:, 3) = current_points(:, 3) * ratio3D;
    [x, y, z, ~, ~, ~] = convert2atlas3D(current_points, ra + repmat(mean(current_points - points), size(ra, 1), 1), rb + repmat(mean(current_points - points), size(rb, 1), 1));
    z = z/max(new_z) * 1.8;
    y = y/2;
    
    % dorsal view
    subplot(3, 2, 2)
    hold on
    plot(x(activeTag), y(activeTag), 'ok', 'MarkerFaceColor','k', 'linewidth', linew);
    if size(LMat,2) >= 1
        for nFactor = 1:size(LMat, 2)
            neuronFactor = LMat(:, nFactor)>0;
            if length(unique(side(neuronFactor)))==1
                CHPoints = smoothedBoundary(x(neuronFactor), y(neuronFactor), radius);
                patch(CHPoints(:,1), CHPoints(:,2), mColor(factorIndex(nFactor), :), 'facealpha', 0.6, 'edgecolor', 'none');
            else
                if sum(side(neuronFactor)==1) == 1 || sum(side(neuronFactor)==2) == 1
                    plot(x(neuronFactor), y(neuronFactor), 'o', 'Color', mColor(factorIndex(nFactor), :), 'MarkerFaceColor', mColor(factorIndex(nFactor), :), 'linewidth', linew)
                else
                    plot(x(neuronFactor), y(neuronFactor), 's', 'Color', mColor(factorIndex(nFactor), :), 'MarkerFaceColor', mColor(factorIndex(nFactor), :), 'MarkerSize', 10, 'linewidth', linew)
                end
            end
        end
    end
    plot(x(~activeTag), y(~activeTag), 'ok', 'linewidth', linew, 'MarkerFaceColor', 'w');
    for i = 1:9
        plot([i, i], [-2, 2], '--k');
    end
    xlim([0 10]);
    ylim([-1 1]);
    hold off
    
    % side view - left
    subplot(3, 2, 6)
    hold on
    plot(x(activeTag & side==1), z(activeTag & side==1), 'ok', 'MarkerFaceColor','k', 'linewidth', linew);
    if size(LMat,2) >= 1
        for nFactor = 1:size(LMat, 2)
            neuronFactor = LMat(:, nFactor)>0;
            if length(unique(side(neuronFactor)))==1 && unique(side(neuronFactor))==1
                CHPoints = smoothedBoundary(x(neuronFactor & side==1), z(neuronFactor & side==1), radius);
                patch(CHPoints(:,1), CHPoints(:,2), mColor(factorIndex(nFactor), :), 'facealpha', 0.6, 'edgecolor', 'none');
            else
                if sum(side(neuronFactor)==1) == 1 || sum(side(neuronFactor)==2) == 1
                    plot(x(neuronFactor & side==1), z(neuronFactor & side==1), 'o', 'Color', mColor(factorIndex(nFactor), :), 'MarkerFaceColor', mColor(factorIndex(nFactor), :), 'linewidth', linew)
                else
                    plot(x(neuronFactor & side==1), z(neuronFactor & side==1), 's', 'Color', mColor(factorIndex(nFactor), :), 'MarkerFaceColor', mColor(factorIndex(nFactor), :), 'MarkerSize', 10, 'linewidth', linew)
                end
            end
        end
    end
    plot(x(~activeTag & side==1), z(~activeTag & side==1), 'ok', 'linewidth', linew, 'MarkerFaceColor', 'w');
    for i = 1:9
        plot([i, i], [0, 2], '--k');
    end
    xlim([0 10]);
    ylim([0 2]);
    hold off
    
    % side view - right
    subplot(3, 2, 4)
    hold on
    plot(x(activeTag & side==2), z(activeTag & side==2), 'ok', 'MarkerFaceColor','k', 'linewidth', linew);
    if size(LMat,2) >= 1
        for nFactor = 1:size(LMat, 2)
            neuronFactor = LMat(:, nFactor)>0;
            if length(unique(side(neuronFactor)))==1 && unique(side(neuronFactor))==2
                CHPoints = smoothedBoundary(x(neuronFactor & side==2), z(neuronFactor & side==2), radius);
                patch(CHPoints(:,1), CHPoints(:,2), mColor(factorIndex(nFactor), :), 'facealpha', 0.6, 'edgecolor', 'none');
            else
                if sum(side(neuronFactor)==1) == 1 || sum(side(neuronFactor)==2) == 1
                    plot(x(neuronFactor & side==2), z(neuronFactor & side==2), 'o', 'Color', mColor(factorIndex(nFactor), :), 'MarkerFaceColor', mColor(factorIndex(nFactor), :))
                else
                    plot(x(neuronFactor & side==2), z(neuronFactor & side==2), 's', 'Color', mColor(factorIndex(nFactor), :), 'MarkerFaceColor', mColor(factorIndex(nFactor), :), 'MarkerSize', 10)
                end
            end
        end
    end
    plot(x(~activeTag & side==2), z(~activeTag & side==2), 'ok', 'linewidth', linew, 'MarkerFaceColor', 'w');
    for i = 1:9
        plot([i, i], [0, 2], '--k');
    end
    xlim([0 10]);
    ylim([0 2]);
    hold off
    frame = getframe(fig);
    writeVideo(video, frame);
end
close(video);
close;

end