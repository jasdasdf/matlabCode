function PlotMazeSpectrogramNormByControl(expTaskType,expFileBaseMat,controlTaskType,controlFileBaseMat,fileext,chanMat,badchan,WinLength,NW,fileNameFormat,subtractBool,dbScale,multByF,samescale,minscale,maxscale,smoothPos,plot_low_thresh)


if ~exist('plot_low_thresh') | isempty(plot_low_thresh)
    plot_low_thresh = 0.1; % thresh to trim plotted values that were smeared by smoothing
end
if ~exist('samescale') | isempty(samescale)
    samescale = 0;
end
if ~exist('badchan') | isempty(badchan)
    badchan = 0;
end
if ~exist('smoothFreq') | isempty(smoothFreq)
    smoothFreq = 0;
end
if ~exist('smoothPos') | isempty(smoothPos)
    smoothPos = 4;
end


if fileNameFormat == 2,
    expFileName = [expTaskType '_' expFileBaseMat(1,:) '-' expFileBaseMat(end,8:10) ...
        fileext '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
    controlFileName = [controlTaskType '_' controlFileBaseMat(1,:) '-' controlFileBaseMat(end,8:10) ...
        fileext '_MazeSpectrogram_Win' num2str(WinLength) '_NW' num2str(NW) '.mat'];
end

if exist(expFileName,'file')
    load(expFileName);
else
    YOU_NEED_TO_RUN_CalcMazeSpectrogram
end
expSumNperPos = sumNperPos;
expSumYFreqPos = sumYFreqPos;
expF = f;
if exist(controlFileName,'file')
    load(controlFileName);
else
    YOU_NEED_TO_RUN_CalcMazeSpectrogram
end
if expF ~= f
    ERROR_expF_NOT_EQUAL_TO_CONTROL_f
end
controlSumNperPos = sumNperPos;
controlSumYFreqPos = sumYFreqPos;

clear sumNperPos;
clear sumYFreqPos;

maxFreq = 120;
freqIndexes = find(f<=maxFreq);

%[nFreq nPos nChan] = size(sumYFreqPos);

if smoothPos ~= 0
    fprintf('\nSmoothing Position...');
    smooth_pos_sum = Smooth(expSumNperPos, [smoothPos]); % smooth position data
    norm_smooth_pos_sum = smooth_pos_sum/sum(sum(smooth_pos_sum));
    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_pos_sum));
    [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
    smooth_pos_sum_nan = smooth_pos_sum;
    smooth_pos_sum_nan(below_thresh_indexes)= NaN;
    smooth_pos_sum_nan_exp = smooth_pos_sum_nan;
else
    expSumNperPos(find(sumNperPos==0)) = NaN;
end


if smoothPos ~= 0
    fprintf('\nSmoothing Position...');
    smooth_pos_sum = Smooth(controlSumNperPos, [smoothPos]); % smooth position data
    norm_smooth_pos_sum = smooth_pos_sum/sum(sum(smooth_pos_sum));
    norm_plot_low_thresh = plot_low_thresh/sum(sum(smooth_pos_sum));
    [below_thresh_indexes] = find(norm_smooth_pos_sum<=norm_plot_low_thresh);
    %[above_thresh_x above_thresh_y] = find(norm_smooth_pos_sum>norm_plot_low_thresh);
    smooth_pos_sum_nan = smooth_pos_sum;
    smooth_pos_sum_nan(below_thresh_indexes)= NaN;
    smooth_pos_sum_nan_control = smooth_pos_sum_nan;
else
    controlSumNperPos(find(sumNperPos==0)) = NaN;
end

powmax = [];
powmin = [];

[chan_y chan_x chan_z] = size(chanMat);

fprintf('\nSmoothing & Plotting Channels:');
for z = 1:chan_z
    figure(z)
    clf
    load('ColorMapSean3.mat')
    colormap(ColorMapSean3);
    for y = 1:chan_y
        for x=1:chan_x
            if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                fprintf('%i,',chanMat(y,x,z));
                if smoothPos ~=0
                    expSmoothAveYFreqPos = Smooth(squeeze(expSumYFreqPos(freqIndexes,:,chanMat(y,x,z))),[smoothPos, smoothFreq]); % smooth power data
                    expMazeSpectrogram = expSmoothAveYFreqPos./repmat(smooth_pos_sum_nan_exp',[length(freqIndexes),1]);
    
                    controlSmoothAveYFreqPos = Smooth(squeeze(controlSumYFreqPos(freqIndexes,:,chanMat(y,x,z))),[smoothPos, smoothFreq]); % smooth power data
                    controlMazeSpectrogram = controlSmoothAveYFreqPos./repmat(smooth_pos_sum_nan_control',[length(freqIndexes),1]);
                else
                    expMazeSpectrogram = squeeze(expSumYFreqPos(freqIndexes,:,chanMat(y,x,z)))./repmat(expSumNperPos',[length(freqIndexes),1]);
                    
                    controlMazeSpectrogram = squeeze(controlSumYFreqPos(freqIndexes,:,chanMat(y,x,z)))./repmat(controlSumNperPos',[length(freqIndexes),1]);
                end
                    
                if subtractBool
                    mazeSpectrogram = expMazeSpectrogram - controlMazeSpectrogram;
                    if dbScale
                        if multByF
                            mazeSpectrogram = mazeSpectrogram.*repmat(f(freqIndexes),[1 size(mazeSpectrogram,2)]);
                        end
                        mazeSpectrogram = 10.*log10(mazeSpectrogram);
                    end
                else
                    mazeSpectrogram = expMazeSpectrogram./controlMazeSpectrogram;
                end
                if 0
                    if percentageBool
                        meanMazeSpectrogram = mean(mazeSpectrogram(:,find(~isnan(mazeSpectrogram(1,:)))),2);
                        [m n] = size(mazeSpectrogram);
                        mazeSpectrogram = mazeSpectrogram./repmat(meanMazeSpectrogram,1,n);
                    elseif dbScale
                        if multByF
                            mazeSpectrogram = mazeSpectrogram.*repmat(f(freqIndexes),[1 size(mazeSpectrogram,2)]);
                        end
                        mazeSpectrogram = 10.*log10(mazeSpectrogram);
                    end
                end
                
                % get rid of excess white space between maze regions
                closestNaNs = find(isnan(mazeSpectrogram(1,1:100-1)));
                lastExp = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:275-1)));
                lastRet = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:400-1)));
                lastDP = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:550-1)));
                lastCA = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:600-1)));
                lastCP = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:750-1)));
                lastRew = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                closestNaNs = find(isnan(mazeSpectrogram(1,1:end)));
                lastWP = find(~isnan(mazeSpectrogram(1,1:closestNaNs(end))));
                
                if 1
                    spacer = 3;
                posIndexes = [1:lastExp(end)+spacer max(100,lastExp(end)+spacer):lastRet(end)+spacer max(275,lastRet(end)+spacer):lastDP(end)+spacer ...
                    max(400,lastDP(end)+spacer):lastCA(end)+spacer max(550,lastCA(end)+spacer):lastCP(end)+spacer max(600,lastCP(end)+spacer):lastRew(end)+spacer ...
                    max(750,lastRew(end)+spacer):lastWP(end)];
                else
                    posIndexes = 1:800;
                end
                
                mazeSpectrogram = mazeSpectrogram(:,posIndexes);
                
                subplot(chan_y,chan_x,(y-1)*chan_x+x);
                imagesc(posIndexes,f(freqIndexes),mazeSpectrogram(:,:));
                title(['Channel: ' num2str(chanMat(y,x,z))]);
                if ~samescale,
                    try, colorbar, catch, end
                end
                powmax = max([max(max(mazeSpectrogram(~isnan(mazeSpectrogram)))) powmax]);
                powmin = min([min(min(mazeSpectrogram(~isnan(mazeSpectrogram)))) powmin]);
            end
        end
    end
end

fprintf('\nScaling...\n');
if samescale,
    for z=1:chan_z
        figure(z)
        for y=1:chan_y
            for x=1:chan_x
                if isempty(find(badchan==chanMat(y,x,z))), % if the channel isn't bad
                    subplot(chan_y,chan_x,(y-1)*chan_x+x);
                    if ~exist('minscale', 'var')
                        set(gca, 'clim', [powmin powmax]);
                    else
                        set(gca, 'clim', [minscale maxscale]);
                    end
                    %set(plothandles(chan_m, i,1), 'clim', [powmin powmax]);
                    try, colorbar, catch, end 
                end
            end
        end
    end
end

for i=1:size(chanMat,3)
    figure(i);
    if fileNameFormat == 2
    text(0,0,{expTaskType,expFileBaseMat(1,1:6),[expFileBaseMat(1,8:10) '-' expFileBaseMat(end,8:10)],'Normalized by',...
        controlTaskType,controlFileBaseMat(1,1:6),[controlFileBaseMat(1,8:10) '-' controlFileBaseMat(end,8:10)],'rl,lr trials',...
        '',fileext,'Position','Spectrogram','','mtcsd','nOverlap=0',['window=' num2str(WinLength)],['NW=' num2str(NW)],...
        '',['smoothFreq=' num2str(smoothFreq)],...
        ['smoothPos=' num2str(smoothPos)]})
    end
end
