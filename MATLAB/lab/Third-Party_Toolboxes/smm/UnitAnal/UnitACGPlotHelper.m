function varargout = UnitSpectrumPlotHelper(dataCell,xVal,varargin)
[xLimits infoText figName colNamesCell reportFigBool saveDir plotColors screenHeight xyFactor,errBarBool] = ...
    DefaultArgs(varargin,{[],{'noInfo'},[],{},0,'./','rgbk',11,1.5,0});

for j=1:5
    if isempty(colNamesCell) | isempty(colNamesCell{j})
        col{j} = unique(dataCell(:,j));
    else
        [junk ia] = intersect(colNamesCell{j},unique(dataCell(:,j)));
        col{j} = colNamesCell{j}(sort(ia));
    end
end

figHandles = [];
for j=1:length(col{1})
    for k=1:length(col{2})
        figHandles = cat(1,figHandles,figure);
        if ~isempty(figName)
            set(gcf,'name',figName)
        end
        SetFigPos([],[0.5,0.5,screenHeight/length(col{3})*length(col{4})...
            *xyFactor,screenHeight])
        for m=1:length(col{3})
            for n=1:length(col{4})
                subplot(length(col{3}),length(col{4}),(m-1)*length(col{4}) + n)
                hold on
                titleText = {};
                nText = ['n='];
                for p=1:length(col{5})
                    if m==1 & n==1 & p==1
                        titleText = cat(1,[col{1}{j} ',' col{2}{k}],infoText);
                    end
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    tempData = dataCell(dataIndexes,6);
                    if ~isempty(tempData) & length(tempData)==1
                        goodCells = sum(isnan(tempData{1}),2)==0;
                        nText = cat(2,nText,[num2str(sum(goodCells,1),3) ',']);
%                         keyboard
%                         expBase = 1.1;
%                         multFact = 2;
%                         expInd = unique(clip(ceil(-multFact+multFact*(expBase.^(0:log(size(tempData{1},2)/multFact)/log(expBase)))),1,size(tempData{1},2)));
%                         xVal(expInd)
                        temp1 = median(tempData{1}(goodCells,:),1);
%                         plot(xVal,temp1,'color',plotColors(p))
%                         temp1 = ExpSmooth(temp1,ones(3,1)/3,1);
%                         shading flat
                        stairs(xVal-median(diff(xVal))/2,temp1,'color',plotColors(p))
                        if errBarBool
                            expInd = p:length(col{5}):size(tempData{1},2);
                            expInd = 1:size(tempData{1},2);
                            rawTemp = tempData{1}(:,expInd);
                            errTemp = [];
                            for r=1:size(rawTemp,2)
                                errTemp(:,r) = BsErrBars(@median,95,100,@median,1,rawTemp(:,r),1);
                            end
                            errBarSamp = expInd;
                                                    stairs([xVal(errBarSamp)]-median(diff(xVal))/2,errTemp([2],:),':','color',plotColors(p))
                                                    stairs([xVal(errBarSamp)]-median(diff(xVal))/2,errTemp([3],:),':','color',plotColors(p))
%                             plot([xVal(errBarSamp); xVal(errBarSamp)],errTemp([2 3],:),'color',[0.35 0.35 0.35])
                        end
                   end
                    if isempty(xLimits)
                        xLimits = get(gca,'xlim');
                    end
                    if p==length(col{5})
                        title(SaveTheUnderscores(cat(1,titleText,nText)))
                    end
                    if n==1 & p==m
                        yLimits = get(gca,'ylim');
                        text(xLimits(2)+0.05*xLimits(2),yLimits(1),...
                            SaveTheUnderscores(col{5}{p}),'color',plotColors(p))
                    end
                    if m==length(col{3})
                        xlabel(SaveTheUnderscores(col{4}{n}))
                    end
                    if n==1
                        ylabel(SaveTheUnderscores(col{3}{m}))
                    end
                    set(gca,'xlim',xLimits)
                end
            end
        end
    end
end
if reportFigBool
    ReportFigSM(figHandles,saveDir);
end
varargout = {figHandles};
varargout=varargout(1:nargout);
return

% plan:



% orderCell - keep order but only use intersection
%
% 
% 
% col4 = subplot x
% col3 = subplot y
% col2 x col1 = figures