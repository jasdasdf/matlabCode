function CalcUnitPopACG05_temp(fileBaseCell,winLen,spectAnalDir,varargin)
%function CalcUnitSpectrum01(fileBaseCell)
%spectAnalDir = 'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8.eeg/';
%winLen = 626;
%[winLen,spectAnalDir] = DefaultArgs(varargin,{winLen,spectAnalDir});

[binSize,normalization] = DefaultArgs(varargin,{3,'scale'});

prevWarnSettings = SetWarnings({'off','MATLAB:divideByZero'});

eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
    
bps = 2;
nChan = load('ChanInfo/NChan.eeg.txt');
%chanLoc = LoadVar('ChanInfo/ChanLoc_Full.eeg.mat');

unitPopACG.infoStruct.eegSamp = eegSamp;
unitPopACG.infoStruct.datSamp = datSamp;
unitPopACG.infoStruct.timeWin = timeWin;
unitPopACG.infoStruct.binSize = binSize;
unitPopACG.infoStruct.winLen = winLen;
unitPopACG.infoStruct.spectAnalDir = spectAnalDir;
unitPopACG.infoStruct.bps = bps;
unitPopACG.infoStruct.nChan = nChan;
unitPopACG.infoStruct.normalization = normalization;
unitPopACG.infoStruct.mfilename = mfilename;


% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    unitPopACG.cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    unitPopACG.cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);

    eegFiles = dir([fileBase '/' fileBase '.eeg']);
    %numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
    elNum = 0;
    catClu = [];
    catRes = [];    
    for k=1:size(unitPopACG.cellLayer,1)
        if elNum ~= unitPopACG.cellLayer{k,1} % saves a little time
            clu = load([fileBase '/' fileBase '.clu.' num2str(unitPopACG.cellLayer{k,1})]);
            res = load([fileBase '/' fileBase '.res.' num2str(unitPopACG.cellLayer{k,1})]);
        end
        elNum = unitPopACG.cellLayer{k,1};
        selRes = find(clu(2:end)==unitPopACG.cellLayer{k,2});
        catRes = cat(1,catRes,res(selRes));
        catClu = cat(1,catClu,k*ones(size(selRes)));
    end
            ccgTemp = [];
            ccgTemp2 = [];
            rateTemp = [];
            for n=1:length(time)
                % calculate ACG
                [ccgTemp toTemp] = CCG(catRes,catClu,...
                    round(binSize*datSamp/1000),round(timeWin/2*1000/binSize),...
                    datSamp,[1:size(unitPopACG.cellLayer,1)],normalization,...
                    [time(n)-timeWin/2 time(n)+timeWin/2]*datSamp);
%                 [ccgTemp toTemp] = CCG(catRes,ones(size(catRes)),...
%                     round(binSize*datSamp/1000),round(timeWin/2*1000/binSize),...
%                     datSamp,1,normalization,...
%                     [time(n)-timeWin/2 time(n)+timeWin/2]*datSamp);
                if isempty(ccgTemp)
                    ccgTemp = zeros(size(ccgTemp,1),1);
                end
                if ~
                ccgTemp2 = cat(1,ccgTemp2,ccgTemp');
                % calculate rate
                selInd = find(catRes>=(time(n)-timeWin/2)*datSamp & catRes<=(time(n)+timeWin/2)*datSamp);
                rateTemp(n,1) = length(selInd)/timeWin;
            end
            if ~isempty(unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).to) & unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).to ~= toTemp
                problem
            else
                unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).to = toTemp;
            end
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).rate = cat(2,unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).rate,rateTemp);
            unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).yo = cat(2,unitPopACG.(cellLayerNames{m}).(cellTypeLabels{p}).yo,permute(ccgTemp2,[1,3,2]));
                   
%             keyboard
%              junk = []
%              junkInd = round((catRes(catRes>(time(n)-timeWin/2)*datSamp & catRes<(time(n)+timeWin/2)*datSamp)...
%                  -(time(n)-timeWin/2)*datSamp)/datSamp*1000);
%              junk(junkInd) = 1;
%             plot(junk)
%             plot(toTemp,ccgTemp2(n,:))
        end
    save([fileBase '/' spectAnalDir 'unitPopACGBin' num2str(binSize) normalization '.mat'],SaveAsV6,'unitPopACG');
end
% catch
%     junk = lasterror
%     %junk.stack
%     keyboard
% end

SetWarnings(prevWarnSettings)