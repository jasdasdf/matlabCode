% function SpectEpochTrough2Res(fileBaseCell,fileExt,spectAnalBase,varargin)
% [nChan chan filtFreqRange maxFreq eegFs resFs bps] = ...
%     DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
%     [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 30],15,1250,20000,2});
function SpectEpochTroughTrigRes(fileBaseCell,fileExt,spectAnalBase,saveNameBlurb,varargin)
[nChan chan filtFreqRange maxFreq eegFs resFs bps] = ...
    DefaultArgs(varargin,{load(['ChanInfo/NChan' fileExt '.txt']),...
    [1:load(['ChanInfo/NChan' fileExt '.txt'])],[4 30],15,1250,1250,2});


for j=1:length(fileBaseCell)
    fileBase = fileBaseCell{j}
    time = LoadVar([fileBase '/' spectAnalBase fileExt '/allEegSegTime'])/eegFs;
    epochs = Times2Epochs(time,median(diff(time)));
    [troughTrigRes.res troughTrigRes.clu] = Trough2Res([fileBase '/' fileBase],nChan,chan,...
        fileExt,filtFreqRange,maxFreq,epochs,eegFs,resFs,bps);
    outBase = ['TroughTrigRes_' saveNameBlurb '_' num2str(filtFreqRange(1)) '-' ...
        num2str(filtFreqRange(2)) 'Hz'];
    fprintf('Saving: %s\n',outBase);
    troughTrigRes.duration = sum(diff(epochs,[],2));
    save([fileBase '/' spectAnalBase fileExt '/' outBase],SaveAsV6,'troughTrigRes')
end