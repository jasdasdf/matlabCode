% AssignCellLayer01(unitAnalDir,fileBase,varargin)
% chanInfoDir = DefaultArgs(varargin,{'ChanInfo/'});
% uses cluloc and ChanLoc_Full.eeg.mat to assign each cell to a layer
function AssignCellLayer01(unitAnalDir,fileBase,varargin)
chanInfoDir = DefaultArgs(varargin,{'ChanInfo/'});

cluLocFile = [unitAnalDir fileBase '.cluloc'];
cellLayerFile = [unitAnalDir fileBase '.cellLayer'];
cluLoc = load(cluLocFile);

if exist(cellLayerFile,'file')
    %& ~strcmp('n',input(['\n' fileBase '.cellLayer exists. Load this file? [y]/n : ','s'))
    cellLayer = LoadCellLayers(cellLayerFile);
else
    chanLocFile = [chanInfoDir 'ChanLoc_Full.eeg.mat'];
    chanLoc = LoadVar(chanLocFile);
    anatLayers = fieldnames(chanLoc);
    for j=1:size(cluLoc,1)
        cellLayer{j,1} = cluLoc(j,1);
        cellLayer{j,2} = cluLoc(j,2);
        for k=1:length(anatLayers)
            if sum([chanLoc.(anatLayers{k}){:}] == cluLoc(j,3))>0
                cellLayer{j,3} = anatLayers{k};
%             else
%                 cellLayer{j,3} = 'noLayer';
            end
        end
    end
    for j=1:size(cellLayer,1)
        if isempty(cellLayer{j,3})
            cellLayer{j,3} = 'noLayer';
        end
    end
    SaveCellLayers(cellLayer,cellLayerFile);
end

while 1
    PlotCellLayers(unitAnalDir,fileBase,chanInfoDir)
    cellLayer
    while 1
        strIn = [];
        strIn = input('\nDo you want to change any layer designations? [y]/n : ','s');
        if strcmp(strIn,'n')
            break;
        end
        elecClu = input('Which elec-clu pair? [elec clu] : ');
        if isempty(elecClu) | sum([cellLayer{:,1}]==elecClu(1) & [cellLayer{:,2}]==elecClu(2))==0
            fprintf('\n%i %i : not found... try again...\n',elecClu(1),elecClu(2))
        else
            newLayer = input('To what layer should they be assigned? : ','s');

            fprintf('\n%i %i %s\n\n',elecClu(1),elecClu(2),newLayer);
            strIn = [];
            strIn = input('Is this correct? n/[y] : ','s');
            if ~strcmp('n',strIn)
                cellLayer{[cellLayer{:,1}]==elecClu(1) & [cellLayer{:,2}]==elecClu(2),3} = newLayer;
                break
            end
        end
    end

    saveVar = input('do yo want to save? [y]/n: ','s');
    if isempty(saveVar) | strcmp(saveVar,'y')
        fNum = 1;
        if ~exist([unitAnalDir 'Old/'],'dir')
            mkdir([unitAnalDir 'Old/'])
        end
        while exist([unitAnalDir 'Old/' fileBase '.cellLayer.old.' num2str(fNum)],'file')
            fNum = fNum+1;
        end
        ['!cp ' cellLayerFile ' ' unitAnalDir 'Old/' fileBase '.cellLayer.old.' num2str(fNum)]
        eval(['!cp ' cellLayerFile ' ' unitAnalDir 'Old/' fileBase '.cellLayer.old.' num2str(fNum)]);

        SaveCellLayers(cellLayer,cellLayerFile);
%         change = 1
    end
     quitVar = input('do yo want to quit? y/[n]: ','s');
     if strcmp(quitVar,'y')
%         if ~isempty(figNums)
%             ReportFigSM(figNums,['NewFigs/ChannelLocalization/'],repmat({date},size(figNums)),[10 8],repmat({{'GCFNAME'}},size(figNums)));
%         end
         return
     end
end

   

    
    
    