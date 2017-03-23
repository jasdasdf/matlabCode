% function outStruct = LoadDesigUnitThresh(fileBaseCell,spectAnalDir,depVar,unitRateVar,rateMin,trialDesig)

function [outStruct keptIndexes] = ...
    LoadDesigUnitPhaseThresh(fileBaseCell,spectAnalDir,depVar,unitRateVar,rateMin,trialDesig)

sumTemp = {};
for k=1:length(fileBaseCell)
    try
        temp = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,depVar,trialDesig),[],1);
        unitRate = Struct2CellArray(LoadDesigVar(fileBaseCell(k),spectAnalDir,unitRateVar,trialDesig),[],1);
    fieldNames = temp(:,1:end-1);
    for m=1:size(fieldNames,1)
        if ~isempty(temp{m,end})
            for n=1:size(unitRate{m,end},2)
                %             temp{m,end}(isnan(temp{m,end}(:))) = 0;
                notNaN = sum(sum(isnan(temp{m,end}(:,n,:,:)),4),3)==0;
                goodRate = unitRate{m,end}(:,n)>=rateMin;
                keptIndexes{k,m,n} = goodRate & notNaN;
                if length(sumTemp)>=m & ~isempty(sumTemp{m}) & length(sumTemp{m})>=n
                    sumTemp{m}{n} = cat(1,sumTemp{m}{n}(:,:,:),...
                        permute(temp{m,end}(keptIndexes{k,m,n},n,:,:),[1,3,4,2]));
                    num(m,n) = num(m,n) + size(temp{m,end}(keptIndexes{k,m,n},n,:,:),1);
                else
                    sumTemp{m}{n} = permute(temp{m,end}(keptIndexes{k,m,n},n,:,:),[1,3,4,2]);
                    num(m,n) = size(temp{m,end}(keptIndexes{k,m,n},n,:,:),1);
                end
            end
        end
    end
    catch
        junk = lasterror
        keyboard
%         fprintf(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n'...
%         'SKIPPING %s\n'...
%         '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'],fileBaseCell{k});
    end
end
    try

outCell = cell(size(fieldNames)+[0 1]);
outCell(:,1:end-1) = fieldNames(:,1:end);
for m=1:size(fieldNames,1)
    for n=1:size(unitRate{m,end},2)
        outCell{m,end}{n} = sumTemp{m}{n};
%         outCell{m,end}(1,n,:,:) = sumTemp{m}(n,:,:) / num(m,n);
    end
end
outStruct = CellArray2Struct(outCell);
    catch
        junk = lasterror
        junk.message
        junk.stack(1)
        keyboard
    end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%
% for m=1:length(sumTemp)
% for n=1:length(sumTemp{m})
%     supbplot(length(sumTemp),length(sumTemp{m}),(m-1)*length(sumTemp{m})+n)
%     hist(mean(sumTemp{m}{n}
%     
    
    