%CheckCohereMean_6_23_06

analRoutine = 'RemVsRun_allTrials';
mfilename = 'GlmWholeModel05';
load(['TrialDesig/' mfilename '/' analRoutine '.mat'])
fileExtCell = {'.eeg','_NearAveCSD1.csd','_LinNearCSD121.csd'}
for m=1:length(fileExtCell)
    fileExt = fileExtCell{m};
    selChans = load(['ChanInfo/SelectedChannels' fileExt '.txt']);
    chanMat = LoadVar(['ChanInfo/ChanMat' fileExt '.mat']);
    badChans = load(['ChanInfo/BadChan' fileExt '.txt']);
    analDir = ['RemVsRun_noExp_MinSpeed0Win1250' fileExt];
    anatCurvesName = 'ChanInfo/AnatCurves.mat';
    offset = load(['ChanInfo/OffSet' fileExt '.txt']);
    normBool = 1;
    fs = LoadField([fileBaseMat(1,:) '/' analDir '/cohSpec.fo']);
    maxFreq = 150;
    thetaFreqRange = [4 12];
    gammaFreqRange = [60 120];


    for j=1:length(selChans)
        selChanNames{j} = ['ch' num2str(selChans(j))];
        cohere.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,['cohSpec.yo.' selChanNames{j}] ,trialDesig);
        phase.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,['phaseSpec.yo.' selChanNames{j}] ,trialDesig);
    end
    for j=1:length(selChans)
        selChanNames{j} = ['ch' num2str(selChans(j))];
        gammaCohere.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['gammaCohMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
        gammaPhase.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['gammaPhaseMean' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
    end
    for j=1:length(selChans)
        selChanNames{j} = ['ch' num2str(selChans(j))];
        thetaCohere.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['thetaCohMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
        thetaPhase.(selChanNames{j}) = LoadDesigVar(fileBaseMat,analDir,...
            ['thetaPhaseMean' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) 'Hz.' selChanNames{j}] ,trialDesig);
    end


    nextFig = 1;
    fields = fieldnames(gammaCohere.(selChanNames{1}));
    for k=1:length(fields)
        for j=1:length(selChans)
            selChanNames{j} = ['ch' num2str(selChans(j))];
            yPlotData = gammaCohere.(selChanNames{j}).(fields{k});
            xPlotData = angle(gammaPhase.(selChanNames{j}).(fields{k}));
            titlesBase = ' ';
            titlesExt = [];
            resizeWinBool = 1;
            filename = GenFieldName([fields{k} fileExt]);
            %PlotScatHelper(nextFig,xPlotData,yPlotData,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
            nPerBin = 75;
            cLimits = [0 nPerBin];
            yBins = round(size(yPlotData,1)/nPerBin);
            xBins = [-pi:2*pi/round(size(yPlotData,1)/nPerBin):pi];
            nextFig = PlotHelperHist2(nextFig,xPlotData,yPlotData,xBins,yBins,cLimits,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
        end
    end
    ReportFigSM(1:nextFig-1,'/u12/smm/public_html/CohCheck_6_23_06/GammaCohMean/')

    nextFig = 1;
    fields = fieldnames(gammaCohere.(selChanNames{1}));
    for k=1:length(fields)
        for j=1:length(selChans)
            selChanNames{j} = ['ch' num2str(selChans(j))];
            yTemp = cohere.(selChanNames{j}).(fields{k})(:,:,fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2));
            xTemp = phase.(selChanNames{j}).(fields{k})(:,:,fs>=gammaFreqRange(1) & fs<=gammaFreqRange(2));
            yPlotData = reshape(permute(yTemp,[1,3,2]),[size(yTemp,1)*size(yTemp,3),size(yTemp,2)]);
            xPlotData = angle(reshape(permute(xTemp,[1,3,2]),[size(xTemp,1)*size(xTemp,3),size(xTemp,2)]));
            titlesBase = ' ';
            titlesExt = [];
            resizeWinBool = 1;
            filename = GenFieldName([fields{k} fileExt]);
            %PlotScatHelper(nextFig,xPlotData,yPlotData,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
            nPerBin = 75;
            cLimits = [0 nPerBin];
            yBins = round(size(yPlotData,1)/nPerBin);
            xBins = [-pi:2*pi/round(size(yPlotData,1)/nPerBin):pi];
            nextFig = PlotHelperHist2(nextFig,xPlotData,yPlotData,xBins,yBins,cLimits,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
        end
    end
    ReportFigSM(1:nextFig-1,'/u12/smm/public_html/CohCheck_6_23_06/GammaSpec/')

    nextFig = 1;
    fields = fieldnames(thetaCohere.(selChanNames{1}));
    for k=1:length(fields)
        for j=1:length(selChans)
            selChanNames{j} = ['ch' num2str(selChans(j))];
            yPlotData = thetaCohere.(selChanNames{j}).(fields{k});
            xPlotData = angle(thetaPhase.(selChanNames{j}).(fields{k}));
            titlesBase = ' ';
            titlesExt = [];
            resizeWinBool = 1;
            filename = GenFieldName([fields{k} fileExt]);
            %PlotScatHelper(nextFig,xPlotData,yPlotData,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
            nPerBin = 75;
            cLimits = [0 nPerBin];
            yBins = round(size(yPlotData,1)/nPerBin);
            xBins = [-pi:2*pi/round(size(yPlotData,1)/nPerBin):pi];
            nextFig = PlotHelperHist2(nextFig,xPlotData,yPlotData,xBins,yBins,cLimits,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
        end
    end
    ReportFigSM(1:nextFig-1,'/u12/smm/public_html/CohCheck_6_23_06/ThetaCohMean/')

    nextFig = 1;
    fields = fieldnames(thetaCohere.(selChanNames{1}));
    for k=1:length(fields)
        for j=1:length(selChans)
            selChanNames{j} = ['ch' num2str(selChans(j))];
            yTemp = cohere.(selChanNames{j}).(fields{k})(:,:,fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2));
            xTemp = phase.(selChanNames{j}).(fields{k})(:,:,fs>=thetaFreqRange(1) & fs<=thetaFreqRange(2));
            yPlotData = reshape(permute(yTemp,[1,3,2]),[size(yTemp,1)*size(yTemp,3),size(yTemp,2)]);
            xPlotData = angle(reshape(permute(xTemp,[1,3,2]),[size(xTemp,1)*size(xTemp,3),size(xTemp,2)]));
            titlesBase = ' ';
            titlesExt = [];
            resizeWinBool = 1;
            filename = GenFieldName([fields{k} fileExt]);
            %PlotScatHelper(nextFig,xPlotData,yPlotData,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
            nPerBin = 75;
            cLimits = [0 nPerBin];
            yBins = round(size(yPlotData,1)/nPerBin);
            xBins = [-pi:2*pi/round(size(yPlotData,1)/nPerBin):pi];
            nextFig = PlotHelperHist2(nextFig,xPlotData,yPlotData,xBins,yBins,cLimits,fileExt,titlesBase,titlesExt,resizeWinBool,filename);
        end
    end
    ReportFigSM(1:nextFig-1,'/u12/smm/public_html/CohCheck_6_23_06/ThetaSpec/')


    clear cohere
    clear phase
    clear gammaCohere
    clear gammaPhase
    clear thetaCohere
    clear thetaPhase

end
