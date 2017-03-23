% function CalcPeakTrigRes(fileBaseCell,fileExt,varargin)
% [nChan chan filtFreqRange maxFreq eegFs resFs bps] = ...
%     DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
%     [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 30],14,1250,20000,2});
% tag:peak
% tag:trig
% tag:res
% tag:clu
% tag:spectral

function CalcPeakTrigRes(fileBaseCell,fileExt,varargin)
[nChan chan filtFreqRange maxFreq eegFs resFs bps] = ...
    DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
    [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 40],14,1250,20000,2});


for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    temp = dir([fileBase '/' fileBase fileExt]);
    epochs = [0 temp.bytes/eegFs/nChan/bps];
    [res clu] = Trough2Res([fileBase '/' fileBase],nChan,chan,...
        fileExt,filtFreqRange,maxFreq,epochs,eegFs,resFs,bps,1,1);
    clu = cat(1,length(unique(clu)),clu);
    outBase = [fileBase '_Peak' num2str(filtFreqRange(1)) '-' ...
        num2str(filtFreqRange(2)) 'Hz_Max' num2str(maxFreq) fileExt];
    fprintf('Saving:\n %s.res\n %s.clu',outBase,outBase);
    msave([fileBase '/' outBase '.res'],res);
    msave([fileBase '/' outBase '.clu'],clu);
end