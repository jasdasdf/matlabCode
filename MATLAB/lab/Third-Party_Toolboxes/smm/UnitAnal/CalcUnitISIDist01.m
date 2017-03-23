% function CalcUnitFieldCoh06(fileBaseCell,fileExt,winLen,spectAnalDir,varargin)
% eegSamp = 1250;
% datSamp = 20000;
% timeWin = winLen/eegSamp;
% selChanCell = Struct2CellArray(LoadVar(['ChanInfo/SelChan' fileExt '.mat']));
% [selChan,fpass,tapers,newSamp,padBool,overwriteBool] = DefaultArgs(varargin,{[selChanCell{:,end}],[0 250],[3 5],eegSamp,0,0});
function CalcUnitFieldCoh06(fileBaseCell,fileExt,winLen,spectAnalDir,varargin)
eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;
binSize = 1;
[binSize,maxT] = DefaultArgs(varargin,{binSize,floor(timeWin*1000/2)});

eegSamp = 1250;
datSamp = 20000;
timeWin = winLen/eegSamp;

prevWarnSettings = SetWarnings({'off', 'MATLAB:divideByZero'});

newWinLen = round(winLen/eegSamp*newSamp);

bps = 2;
nChan = load(['ChanInfo/NChan' fileExt '.txt']);

%%%%%%% fix!!!
paramb = [];
paramb.fpass = fpass;
paramb.Fs = newSamp;
paramb.pad = padBool;
paramb.tapers = tapers;
infoStruct.mfilename = mfilename;
infoStruct.paramb = paramb;
unitFieldCoh.paramb = paramb;
unitFieldPhase.paramb = paramb;
unitFieldCrossSpec.paramb = paramb;

% try
for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalDir 'time.mat']);
    cellLayer = LoadCellLayers([fileBase '/' fileBase '.cellLayer']);
    cellType = LoadCellTypes([fileBaseCell{1} '/' fileBaseCell{1} '.type']);
    
    updatingBool = 0;
    skippingBool = 0;
    %%%% Check if files exist and can be updated %%%%%
    saveDir = [SC(fileBase) SC(spectAnalDir)];
    oldFCname = ['unitISIDistBin' num2str(binSize) '.mat'];
    if exist([SC(saveDir) oldFCname]...
            ,'file') & ~overwriteBool
        oldUnitFieldCoh = LoadVar([SC(saveDir)...
            oldFCname]);
        %%%%%%% FIX!!!!!!
        if size(oldUnitFieldCoh.yo,1) < size(time,1)
            timeLen = length(time);
            time = time(size(oldUnitFieldCoh.yo,1)+1:timeLen);
            fprintf(['Updating: ' SC(saveDir) oldFCname ', trials '...
                num2str(size(oldUnitFieldCoh.yo,1)+1) '-' num2str(timeLen) '\n'])
            infoStruct.(['updated_' GenFieldName(date)]) = ...
                [size(oldUnitFieldCoh.yo,1)+1:timeLen,1];
            updatingBool = 1;
        elseif size(oldUnitFieldCoh.yo,1) > size(time,1)
            error([mfilename ':TimeTooSmall'],['Variable time is shorter than '...
               oldFCname '.yo: that is bad'])
        else
            warning([mfilename ':FileAlreadyUpToDate'],['File '...
                SC(saveDir) oldFCname ' is already up time date: SKIPPING']);
            skippingBool = 1;
        end
        clear oldUnitFieldCoh;
    end

    if ~skippingBool
        unitISIDist.cellLayer = cellLayer;
        unitISIDist.cellType = cellType;
        unitISIDist.t = [];
        unitISIDist.pd = [];
        unitISIDist.mean = [];
        unitISIDist.cv = [];

        eegTrials = zeros(length(time),length(selChan),winLen);
        for n=1:length(time)
            tempEEG = bload([fileBase '/' fileBase fileExt],[nChan winLen],...
                round((time(n)-timeWin/2)*eegSamp*nChan*bps));
            eegTrials(n,:,:) = tempEEG(selChan,:);
        end
        eegFiles = dir([fileBase '/' fileBase fileExt]);
        numNewSamp = ceil(eegFiles(1).bytes/bps/nChan/eegSamp*newSamp);
        elNum = 0;
        for k=1:size(cellLayer,1)
            if elNum ~= cellLayer{k,1}
                clu = load([fileBase '/' fileBase '.clu.' num2str(cellLayer{k,1})]);
                res = load([fileBase '/' fileBase '.res.' num2str(cellLayer{k,1})]);
            end
            elNum = cellLayer{k,1};
            selRes = res(clu(2:end)==cellLayer{k,2});
            if ~isempty(selRes)
                spikeBin = Accumulate(round(selRes/datSamp*newSamp),1,numNewSamp);
            else
                spikeBin = zeros(numNewSamp,1);
            end
            trialBin = [];
            for n=1:length(time)
                spikeBinStartInd = max(1,round((time(n)-timeWin/2)*newSamp));
                trialBin(n,:) = spikeBin(spikeBinStartInd:min(spikeBinStartInd+newWinLen-1,numNewSamp));
                %spikeBinStartInd = find(spikeBinTime>=time(n)-round(timeWin/2),1);
                %trialBin(n,:) = spikeBin(spikeBinStartInd:spikeBinStartInd+newWinLen);
            end
       keyboard
     [t, pd, mean, cv] = isidist(res,1,[0 50],1/2000);
     junk = round(rand(1000,1));
     isidist(junk,1,50,1)
          for m=1:length(selChan)
                [cohTemp phiTemp csdTemp spec1Junk spec2Junk foTemp zerospTemp] = ...
                    coherencycpb(permute(eegTrials(:,m,:),[3 1 2]),trialBin',paramb);
                %         [specTemp,foTemp,rateTemp]=mtspectrumpb(trialBin',paramb);
                if ~isempty(unitISIDist.fo) & unitISIDist.fo ~= foTemp
                    problem
                else
                    unitISIDist.fo = foTemp;
                end
                if isempty(unitISIDist.yo)
                    unitISIDist.yo = zeros([length(time) size(cellLayer,1) ...
                        length(selChan) size(cohTemp,1)]);
                    unitISIDist.zerosp = zeros([length(time) size(cellLayer,1)]);

                    unitFieldPhase.yo = zeros([length(time) size(cellLayer,1) ...
                        length(selChan) size(cohTemp,1)]);
                    unitFieldPhase.zerosp = zeros([length(time) size(cellLayer,1)]);

                    unitFieldCrossSpec.yo = zeros([length(time) size(cellLayer,1) ...
                        length(selChan) size(cohTemp,1)]);
                    unitFieldCrossSpec.zerosp = zeros([length(time) size(cellLayer,1)]);
                end
                unitISIDist.yo(:,k,m,:) = permute(cohTemp,[2,3,1]);
                unitISIDist.fo = foTemp;
                unitISIDist.zerosp(:,k) = zerospTemp;

                unitFieldPhase.yo(:,k,m,:) = permute(phiTemp,[2,3,1]);;
                unitFieldPhase.fo = foTemp;
                unitFieldPhase.zerosp(:,k) = zerospTemp;

                unitFieldCrossSpec.yo(:,k,m,:) = permute(csdTemp,[2,3,1]);;
                unitFieldCrossSpec.fo = foTemp;
                unitFieldCrossSpec.zerosp(:,k) = zerospTemp;
            end
        end
        if updatingBool
            oldunitISIDist = LoadVar([SC(saveDir)...
                'unitISIDist_orig_tapers' num2str(paramb.tapers(2)) '.mat']);
            oldUnitFieldPhase = LoadVar([SC(saveDir)...
                'unitFieldPhase_tapers' num2str(paramb.tapers(2)) '.mat']);
            oldUnitFieldCrossSpec = LoadVar([SC(saveDir)...
                'unitFieldCrossSpec_tapers' num2str(paramb.tapers(2)) '.mat']);
            if unitISIDist.fo ~= oldunitISIDist.fo | ...
                    unitISIDist.fo ~= oldUnitFieldPhase.fo | ...
                    unitISIDist.fo ~= unitFieldCrossSpec.fo | ...
                    CellNE(unitISIDist.cellLayer,oldunitISIDist.cellLayer) | ...
                    CellNE(unitISIDist.cellType,oldunitISIDist.cellType)
                error([mfilename 'CannotUpdate'],'Previous calculations do not match current')
            else

                unitISIDist.yo = cat(1,oldunitISIDist.yo,unitISIDist.yo);
                unitISIDist.zerosp = cat(1,oldunitISIDist.zerosp,unitISIDist.zerosp);

                unitFieldPhase.yo = cat(1,oldUnitFieldPhase.yo,unitFieldPhase.yo);
                unitFieldPhase.zerosp = cat(1,oldUnitFieldPhase.zerosp,unitFieldPhase.zerosp);

                unitFieldCrossSpec.yo = cat(1,oldUnitFieldCrossSpec.yo,unitFieldCrossSpec.yo);
                unitFieldCrossSpec.zerosp = cat(1,oldUnitFieldCrossSpec.zerosp,unitFieldCrossSpec.zerosp);

                if isfield(oldunitISIDist,infoStruct)
                    infoStruct = MergeStructs(oldunitISIDist.infoStruct,infoStruct);
                end
            end
        end

        unitISIDist.infoStruct = infoStruct;
        unitFieldPhase.infoStruct = infoStruct;
        unitFieldCrossSpec.infoStruct = infoStruct;

        save([fileBase '/' spectAnalDir 'unitISIDist_orig_tapers' num2str(paramb.tapers(2)) '.mat'],SaveAsV6,'unitISIDist');
        unitISIDist.yo = ATanCoh(unitISIDist.yo);
        save([fileBase '/' spectAnalDir 'unitISIDist_ATan_tapers' num2str(paramb.tapers(2)) '.mat'],SaveAsV6,'unitISIDist');
        save([fileBase '/' spectAnalDir 'unitFieldPhase_tapers' num2str(paramb.tapers(2)) '.mat'],SaveAsV6,'unitFieldPhase');
        save([fileBase '/' spectAnalDir 'unitFieldCrossSpec_tapers' num2str(paramb.tapers(2)) '.mat'],SaveAsV6,'unitFieldCrossSpec');
        %unitPowSpec
        %firingRate.elClu
    end
end
SetWarnings(prevWarnSettings);
% catch
%     junk = lasterror
%     junk.stack
%     keyboard
% end