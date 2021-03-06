% function CalcFlatTrials01(saveDir,fileBaseCell,flatExt,flatSamp,winLen,varargin)
% [eegSamp,plotBool] = DefaultArgs(varargin,{1250,1})
function CalcFlatTrials01(saveDir,fileBaseCell,flatExt,flatSamp,winLen,varargin)
[eegSamp,plotBool] = DefaultArgs(varargin,{1250,1});

for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j};
    flatFile = [fileBase '/' fileBase flatExt '.flat.txt'];
    outFile = [fileBase '/' saveDir '/flat.mat'];
    eegSegTime = LoadVar([fileBase '/' saveDir '/eegSegTime']); %load spectAnalTimes
    flatEpochs = load(flatFile)*eegSamp/flatSamp; % load flatEpochs
    
    flat = logical(zeros(size(eegSegTime)));
    if ~isempty(flatEpochs)
        for k=1:size(eegSegTime,1)
            if any( (flatEpochs(:,1)>=eegSegTime(k) & flatEpochs(:,1)<=eegSegTime(k)+winLen) ...
                    | (flatEpochs(:,2)>=eegSegTime(k) & flatEpochs(:,2)<=eegSegTime(k)+winLen) ...
                    | (flatEpochs(:,1)<=eegSegTime(k) & flatEpochs(:,2)>=eegSegTime(k)+winLen));
                flat(k,1) = 1;
            end
        end
        if plotBool
            figure
            hold on
            PlotVertLines(flatEpochs(:,1),[0 2],...
                'color','g')
            PlotVertLines(flatEpochs(:,2),[0 2],...
                'color','r')
            plot([eegSegTime(~flat) eegSegTime(~flat)+winLen]',repmat([1 1],[sum(~flat) 1])',...
                'c')
            plot([eegSegTime(flat) eegSegTime(flat)+winLen]',repmat([1 1],[sum(flat) 1])',...
                'k')
            plot([eegSegTime(~flat) eegSegTime(~flat)+winLen]',repmat([1 1],[sum(~flat) 1])',...
                'c.')
            plot([eegSegTime(flat) eegSegTime(flat)+winLen]',repmat([1 1],[sum(flat) 1])',...
                'k.')
            %         set(gca,'xlim',[unionEpochs(1,1) unionEpochs(1,1)+Fs*plotDuration]);
            set(gcf,'name',[fileBase flatExt '_FlatTimes'])
            SetFigPos(gcf,[0.5 0.5 15 5]);
        end
    end
    save(outFile,SaveAsV6,'flat');
end
    
    

