function PlotPlaceFields03(fileBaseCell,varargin)
temp.AllTrials = [1 1 1 1 1 1 1 1 1 1 1 1 1];
trialTypesBoolStruct = DefaultArgs(varargin,{temp});

nEl = 11;
maxClu = 6;
topRate = zeros(nEl,maxClu);
trialTypes = fieldnames(trialTypesBoolStruct);
for n=1:length(trialTypes)
    figure
    set(gcf,'unit','inches')
    set(gcf,'position',[0.5 0.5 17 10])
    set(gcf,'paperposition',[0.5 0.5 17 10])
    %set(gcf,'name',trialTypes{n})
    trialTypesBool = trialTypesBoolStruct.(trialTypes{n});
    %trialTypesBool = [1 1 1 1 1 1 1 1 1 1 1 1 1]; %AllTrials
    %trialTypesBool = [1 0 1 0 0 0 0 0 0 0 0 0 0]; %GoodTrials
    %trialTypesBool = [0 0 1 0 0 0 1 0 0 0 1 0 0]; %RLAll
    %trialTypesBool = [1 0 0 0 1 0 0 0 1 0 0 0 0]; %LRAll
    %trialTypesBool = [0 1 0 0 0 1 0 0 0 1 0 0 0]; %RRAll
    %trialTypesBool = [0 0 0 1 0 0 0 1 0 0 0 1 0]; %LLAll
    %trialTypesBool = [1 0 1 0 1 0 1 0 1 0 1 0 0]; %AllCorrect
    %trialTypesBool = [0 1 0 1 0 1 0 1 0 1 0 1 0]; %AllIncorrect
    
    mazeLocBool = [1 1 1 1 1 1 1 1 1];
    for m = 1:length(fileBaseCell)
        fileBase = fileBaseCell{m}
        cd(fileBase);
        pos = LoadMazeTrialTypes([fileBase],trialTypesBool,mazeLocBool);
        cluLoc = load([fileBase '.cluloc']);
        cellType = LoadCellTypes([fileBase '.type']);
        neuronQuality = LoadVar([fileBase '.NeuronQuality.mat']);
        for k=1:nEl
            res = load([fileBase '.res.' num2str(k)]);
            clu = load([fileBase '.clu.' num2str(k)]);

            for j=2:clu(1)-1
                selRes = res(find(clu==j)-1);
                %subplot(maxClu,nEl,(j-2)*nEl+k)
                %keyboard
                [PlaceMap(m,k,j,:,:), OccupancyMap(m,k,j,:,:)] = PlaceField(selRes,pos);
            end
        end
        cd ..
    end
    for k=1:nEl
        for j=2:maxClu+1
            placeMapTemp = squeeze(sum(PlaceMap(:,k,j,:,:)));
            occupancyMapTemp = squeeze(sum(OccupancyMap(:,k,j,:,:)));
            topRate(k,j-1) = max([topRate(k,j) max(placeMapTemp(find(occupancyMapTemp>1)))]);
        end
    end
    for k=1:nEl
        for j=2:maxClu+1
            placeMapTemp = squeeze(sum(PlaceMap(:,k,j,:,:)));
            occupancyMapTemp = squeeze(sum(OccupancyMap(:,k,j,:,:)));
%             if n==1
%                 topRate(k,j) = max(placeMapTemp(find(occupancyMapTemp>1)));
%             end
            subplot(maxClu,nEl,(j-2)*nEl+k)
            PFPlot(placeMapTemp,occupancyMapTemp,topRate(k,j-1));
            set(gca,'xtick',[],'ytick',[])
            if j-1 <=length(neuronQuality(k).eDist)
                neuroQual = neuronQuality(k).eDist(j-1);
            else
                neuroQual = [];
            end
            title(['ch' num2str(cluLoc(cluLoc(:,1)==k & cluLoc(:,2)==j,3)) ...
                ',' cellType{cell2mat(cellType(:,1))==k & cell2mat(cellType(:,2))==j,3} ...
                ',' num2str(neuroQual)]);
            if k==1 & j==maxClu+1
                xlabel(trialTypes{n})
            end
        end
    end
end
    TopRate = max(FireRate(find(sTimeSpent>TimeThresh)));